defmodule PropyWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    Logger.info("Starting propy-web.." <> Application.app_dir(:propy_web))

    children = [
      {Plug.Cowboy,
       scheme: :http,
       plug: PropyWeb.Plug,
       options: [port: 4002]}
    ]

    opts = [strategy: :one_for_one, name: PropyWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
