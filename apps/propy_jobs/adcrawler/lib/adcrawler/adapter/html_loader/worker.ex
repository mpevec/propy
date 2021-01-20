defmodule Adcrawler.Adapter.HtmlLoader.Worker do
  @moduledoc """
    Worker for domain process of 'loading html'
  """
  use GenServer
  alias Adcrawler.Adapter.GenServerLogger

  defmodule State do
    @moduledoc false
    defstruct retries: 0, delay_ms: 0, task_ref: nil, zip_code: nil, page_num: nil

    def new(retries, delay_ms) do
      %State{
        retries: retries,
        delay_ms: delay_ms,
        task_ref: nil,
        zip_code: nil,
        page_num: nil
      }
    end
  end

  @load_request_id :get
  @get_next_page_request_id :get_next_page
  @domain Adcrawler.Domain.LoadingHtml
  @next_server Adcrawler.Adapter.AdCrawler.Worker

  # API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def load(page_num, zip_code) do
    GenServer.call(__MODULE__, {@load_request_id, page_num, zip_code})
  end

  def get_next_page do
    GenServer.call(__MODULE__, {@get_next_page_request_id})
  end

  # Callbacks
  def init(opts) do
    state = State.new(Keyword.get(opts, :retries), Keyword.get(opts, :delay_ms))
    {:ok, state}
  end

  def handle_call({@load_request_id, page_num, zip_code} = _call, _from, %State{task_ref: nil} = state) do
    GenServerLogger.handle_call(__MODULE__, @load_request_id)

    task = create_task(page_num, zip_code)
    state = state
      |> Map.put(:task_ref, task.ref)
      |> Map.put(:page_num, page_num)
      |> Map.put(:zip_code, zip_code)

    {:reply, state, state}
  end

  def handle_call({@get_next_page_request_id} = _call, _from, %State{task_ref: nil, page_num: page_num, zip_code: zip_code} = state) do
    GenServerLogger.handle_call(__MODULE__, @get_next_page_request_id, "Last page req: #{page_num}")

    page_num = page_num + 1
    task = create_task(page_num, zip_code)
    state = state
      |> Map.put(:task_ref, task.ref)
      |> Map.put(:page_num, page_num)

    {:reply, state, state}
  end

  # Success
  def handle_info({task_ref, {:ok, html}} = _info, %State{zip_code: zip_code} = state) do
    GenServerLogger.handle_info(__MODULE__, :ok, [task_ref: task_ref])

    # At that point we will know the task is complete and won’t want its :DOWN message,
    # so we’ll demonitor the process and :flush its :DOWN message from our mailbox if it’s already there.
    Process.demonitor(task_ref, [:flush])

    @next_server.crawl_ads(html, zip_code)

    state = state |> Map.put(:task_ref, nil)
    {:noreply, state}
  end

  # Expected failure
  def handle_info({task_ref, {:error, reason}} = _info, %State{} = state) do
    GenServerLogger.handle_info(__MODULE__, :error, [task_ref: task_ref, message: reason])

    # At that point we will know the task is complete and won’t want its :DOWN message,
    # so we’ll demonitor the process and :flush its :DOWN message from our mailbox if it’s already there.
    Process.demonitor(task_ref, [:flush])

    # We should reset retry counter to start from scratch
    retry(state)
  end

  # Unexpected failure
  def handle_info({:DOWN, _ref, :process, _pid, _reason} = info, %State{} = state) do
    GenServerLogger.handle_info(__MODULE__, :DOWN, [info: info])
    retry(state)
  end

  # retry the task
  defp retry(%State{page_num: page_num, retries: retries, delay_ms: delay_ms, zip_code: zip_code} = state) do
    if retries > 0 do
      GenServerLogger.retry_and_delay(__MODULE__, "request html for page_num: #{page_num}", retries, delay_ms)
      Process.sleep(delay_ms)
      task = create_task(page_num, zip_code)
      state = state |> Map.put(:retries, retries - 1) |> Map.put(:task_ref, task.ref)
      {:noreply, state}
    else
      GenServerLogger.no_retry_left(__MODULE__)
      IO.puts("No retries left for restart!")
      {:noreply, state}
    end
  end

  @spec create_task(integer(), String.t()) :: %Task{owner: pid(), pid: pid(), ref: reference()}
  defp create_task(page_num, zip_code) do
    Task.Supervisor.async_nolink(Task.Supervisor.Adcrawler, fn ->
      @domain.load(page_num, zip_code)
    end)
  end
end
