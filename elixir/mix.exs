defmodule Stoat.MixProject do
  use Mix.Project

  def project do
    [
      app: :stoat,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Example.App, []}
    ]
  end

  defp deps do
    [
      {:uuid, "~> 1.1"},
      {:ecto, "~> 3.10"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:typed_struct, "~> 0.3.0"}
    ]
  end
end
