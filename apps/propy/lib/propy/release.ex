defmodule Propy.Release do
  @moduledoc """
    After release ecto migration logic
  """
  @app :propy

  def migrate do
    Application.load(@app)

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def migrate_and_start do
    IO.puts("..Migrate & Start..")
    migrate()
    case Application.ensure_all_started(@app, :permanent) do
      {:ok, _} -> System.no_halt(true)
      _ = error -> error
    end
  end

  def rollback(repo, version) do
    Application.load(@app)
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end
end
