defmodule EctoAssocQuery.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_assoc_query,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {EctoAssocQuery.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:postgrex, "~> 0.18.0"},
      {:ecto_sql, "~> 3.11"},
      {:csv, "~> 3.2"}
    ]
  end
end
