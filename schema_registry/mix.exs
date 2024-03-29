defmodule SchemaRegistry.MixProject do
  use Mix.Project

  def project do
    [
      app: :schema_registry,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_json_schema, "~> 0.10.2"},
      {:jason, "~> 1.4"}
    ]
  end
end
