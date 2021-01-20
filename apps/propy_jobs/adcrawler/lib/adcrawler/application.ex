defmodule Adcrawler.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      Adcrawler.Repo,
      {Task.Supervisor, name: Task.Supervisor.Adcrawler},
      {Adcrawler.Adapter.HtmlLoader.Worker, [retries: 15, delay_ms: 1000]},
      Adcrawler.Adapter.AdCrawler.Worker,
    ]
    opts = [strategy: :one_for_one, name: Adcrawler.Supervisor]
    # Following calls start_link on every child
    Supervisor.start_link(children, opts)
  end
end
