defmodule PropyWeb.MixProject do
  use Mix.Project

  def project do
    [
      app: :propy_web,
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
      mod: {PropyWeb.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:reverse_proxy_plug, "~> 1.3.2"},
      {:ok_jose, "~> 3.0.0"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.2"},
    ]
  end
end
