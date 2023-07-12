defmodule ExMessageDB.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_message_db,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      dialyzer: [flags: [:error_handling, :race_conditions, :underspecs, :unmatched_returns]],
      deps: deps(),
      description: description(),
      package: package(),
      name: "ExMessageDB",
      source_url: "https://github.com/josemrb/ex_message_db",
      docs: docs()
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
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:credo_contrib, "~> 0.2.0", only: [:dev, :test], runtime: false},
      {:credo_naming, "~> 0.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ecto_sql, "~> 3.4"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:ex_machina, "~> 2.4", only: :test},
      {:jason, "~> 1.2"},
      {:postgrex, "~> 0.15"}
    ]
  end

  defp description do
    """
    An Elixir client for Message DB.
    """
  end

  defp docs do
    [main: "readme", extras: ["README.md"]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/josemrb/ex_message_db"},
      files: ["lib", "priv", "mix.exs", "README*", "LICENSE*"]
    ]
  end
end
