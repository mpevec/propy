defmodule Adcrawler.Adapter.GenServerLogger do
  @moduledoc """
    Custom wrapper around Logger for logging GenServer points of interest
  """
  require Logger

  def handle_call(server, request_id, extra \\ "") do
    Logger.info("GenServer (#{server}) 'handle_call' (request: #{request_id}) detected. (#{extra}")
  end

  def handle_info(server, type, opts) do
    case type do
      :ok -> Logger.info("GenServer (#{server}) 'handle_info' (pattern :ok) detected for task ref: #{inspect(Keyword.get(opts, :task_ref))}.")
      :error -> Logger.info("GenServer (#{server}) 'handle_info' (pattern :error) detected for task ref: #{inspect(Keyword.get(opts, :task_ref))}, with message:\n#{inspect(Keyword.get(opts, :message))}")
      :DOWN -> Logger.info("GenServer (#{server}) 'handle_info' (pattern :DOWN) detected, with info:\n#{inspect(Keyword.get(opts, :info))}")
    end
  end

  def retry_and_delay(server, what, retries_left, delay_ms) do
    Logger.info("GenServer (#{server}), retrying to #{what} (retries left: #{retries_left}). Using delay of #{delay_ms} ms.")
  end

  def no_retry_left(server) do
    Logger.info("GenServer (#{server}), no retries left!")
  end
end
