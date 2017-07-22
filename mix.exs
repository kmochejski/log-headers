defmodule LogHeaders.Mixfile do
  use Mix.Project

  @version "0.0.1"

  def project do
    [app: :log_headers,
     version: @version,
     elixir: "~> 1.4",
     description: "A plug for logging request headers.",
     deps: deps()]
  end

  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:plug, "~> 1.0"}]
  end
end
