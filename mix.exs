defmodule ExclosuredApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :exclosured_app,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {ExclosuredApp.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp deps do
    [
      {:phoenix, "~> 1.7"},
      {:phoenix_live_view, "~> 1.0"},
      {:jason, "~> 1.0"},
      {:bandit, "~> 1.0"}
    ]
  end
end
