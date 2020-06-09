defmodule ExMessageDB.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_message_db,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ExMessageDB.Application, []}
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.4"},
      {:jason, "~> 1.2"},
      {:postgrex, "~> 0.15"},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
