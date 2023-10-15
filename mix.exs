defmodule Mix.Tasks.EyeDrops.Mixfile do
  use Mix.Project

  def project do
    [
      app: :eye_drops,
      version: "1.5.0",
      elixir: "~> 1.13",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      aliases: aliases()
    ]
  end

  def application, do: [extra_applications: [:logger, :file_system]]


  defp aliases do
    [ci: ci_mix(), acceptance: [&accept/1]]
  end

  def accept(_) do
    Mix.shell().info("****** FAKE ACCEPTANCE RAN ******")
  end

  defp deps do
    [
      {:mock, "~> 0.3.8", only: :test},
      {:credo, "~> 1.7.0", only: [:dev, :test]},
      {:ex_doc, "~> 0.30.6", only: :dev},
      {:file_system, "~> 0.2.10", only: [:dev, :test]},
      {:mix_test_watch, "~> 1.1.0", only: [:dev, :test]}
    ]
  end

  defp description do
    """
    A configurable mix task to watch file changes
    Watch file changes in a project and run the corresponding command when a change happens.
    """
  end

  defp package do
    [
      files: ["lib/**/*ex", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Richard Kotze"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/rkotze/eye_drops",
        "Docs" => "https://github.com/rkotze/eye_drops/blob/master/README.md"
      }
    ]
  end

  defp ci_mix() do
    [
      "credo -a",
      "test"
    ]
  end
end
