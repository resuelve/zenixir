defmodule Zenixir.Mixfile do
  use Mix.Project

  def project do
    [
      app: :zenixir,
      version: "0.1.6",
      elixir: ">= 1.7.4",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      description: description(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  defp description do
    """
    Elixir Zendesk API Client http://developer.zendesk.com/
    """
  end

  defp deps do
    [
      {:httpoison, "~> 1.2"},
      {:poison, "~> 3.0"},
      {:exprintf, github: "parroty/exprintf"},
      {:exvcr, "~> 0.10", only: :test},
      {:excoveralls, "~> 0.9.1"},
      {:inch_ex, ">= 0.0.0", only: :docs},
      {:ex_doc, "~> 0.12", only: :dev}
    ]
  end
end
