defmodule Adcrawler.MixProject do
  use Mix.Project

  def project do
    [
      app: :adcrawler,
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
      mod: {Adcrawler.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:httpoison, "~> 1.6"},
      {:floki, "~> 0.29.0"},
      {:ecto_sql, "~> 3.5"},
      {:postgrex, ">= 0.0.0"},
      {:ok_jose, "~> 3.0.0"}
    ]
  end
end
