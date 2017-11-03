defmodule Instamojo.Mixfile do
  use Mix.Project

  def project do
    [
      app: :instamojo,
      version: "0.1.0",
      elixir: "~> 1.5",
      description: "Elixir bindings for Instamojo REST API",
      source_url: "https://github.com/sasankyadavalli/instamojo",
      package: package(),
      start_permanent: Mix.env == :prod,
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
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:ex_doc, "~> 0.16", only: [:dev, :test]},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end

  defp description() do
    "Elixir bindings for Instamojo REST API"
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "instamojo",
      # These are the default files included in the package
      maintainers: ["Sasank Yadavalli"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/sasankyadavalli/instamojo"}
    ]
  end
end
