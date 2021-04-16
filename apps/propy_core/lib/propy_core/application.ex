defmodule PropyCore.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      PropyCore.Repo,
    ]
    opts = [strategy: :one_for_one, name: PropyCore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
