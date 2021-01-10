defmodule Propy.MixProject do
  use Mix.Project

  def project do
    [
      app: :propy,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Propy.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cors_plug, "~> 2.0"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.2"},
      {:jose, "~> 1.10.1"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ecto_sql, "~> 3.5"},
      {:postgrex, ">= 0.0.0"},
      {:httpoison, "~> 1.6"},
      {:floki, "~> 0.29.0"},
      {:ok_jose, "~> 3.0.0"}
    ]
  end
end
