defmodule PropyWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    port = Application.fetch_env!(:propy_web, :cowboy_port)
    Logger.info("Starting propy-web on port: #{port}...")

    children = [
      {Plug.Cowboy,
       scheme: :http,
       plug: PropyWeb.Plug,
       options: [port: port]}
    ]

    opts = [strategy: :one_for_one, name: PropyWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
