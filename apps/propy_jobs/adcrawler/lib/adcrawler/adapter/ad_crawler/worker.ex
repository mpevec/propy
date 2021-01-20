defmodule Adcrawler.Adapter.AdCrawler.Worker do
  @moduledoc """
    Worker for domain process of 'crawling ads'
  """
  use GenServer
  alias Adcrawler.Adapter.GenServerLogger

  defmodule State do
    @moduledoc false
    defstruct task_ref: nil
  end

  @crawl_ads_request_id :crawl_ads
  @domain Adcrawler.Domain.CrawlingAds
  @next_server Adcrawler.Adapter.HtmlLoader.Worker

  # API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def crawl_ads(html, zip_code) do
    GenServer.call(__MODULE__, {@crawl_ads_request_id, html, zip_code})
  end

  # Callbacks
  def init(_opts) do
    state = %State{task_ref: nil}
    {:ok, state}
  end

  def handle_call({@crawl_ads_request_id, html, zip_code} = _call, _from, %State{} = state) do
    GenServerLogger.handle_call(__MODULE__, @crawl_ads_request_id)

    task = create_task(html, zip_code)
    state = state |> Map.put(:task_ref, task.ref)

    {:reply, state, state}
  end

  # Success
  def handle_info({task_ref, {:ok, _answer}} = _info, %State{} = state) do
    GenServerLogger.handle_info(__MODULE__, :ok, [task_ref: task_ref])

    # At that point we will know the task is complete and won’t want its :DOWN message,
    # so we’ll demonitor the process and :flush its :DOWN message from our mailbox if it’s already there.
    Process.demonitor(task_ref, [:flush])

    @next_server.get_next_page()

    state = state |> Map.put(:task_ref, nil)
    {:noreply, state}
  end

  # Expected failure
  def handle_info({task_ref, {:error, reason}} = _info, %State{} = state) do
    GenServerLogger.handle_info(__MODULE__, :error, [task_ref: task_ref, message: reason])

    # At that point we will know the task is complete and won’t want its :DOWN message,
    # so we’ll demonitor the process and :flush its :DOWN message from our mailbox if it’s already there.
    Process.demonitor(task_ref, [:flush])

    {:noreply, state}
  end

  # Unexpected failure
  def handle_info({:DOWN, _ref, :process, _pid, _reason} = info, %State{} = state) do
    GenServerLogger.handle_info(__MODULE__, :DOWN, [info: info])

    {:noreply, state}
  end

  @spec create_task(String.t(), String.t()) :: %Task{owner: pid(), pid: pid(), ref: reference()}
  defp create_task(html, zip_code) do
    Task.Supervisor.async_nolink(Task.Supervisor.Adcrawler, fn ->
      @domain.crawl_for_ads(html, zip_code)
    end)
  end
end
