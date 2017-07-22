defmodule LogHeaders do
  @moduledoc """
  A plug for logging request headers in the following format:
      [info] header-a: value-a, header-b: value-b

  To use it, just plug it into the desired module.
      plug LogHeaders, log: :debug

  ## Options
    * `:log` - The log level at which this plug should log headers.
      Default is `:info`.
  """
  require Logger
  @behaviour Plug

  def init(opts) do
    Keyword.get(opts, :log, :info)
  end

  def call(conn, level) do
    case conn.req_headers do
      [] ->
        conn
      headers ->
        Logger.log(level, headers_to_string(headers))
        conn
    end
  end

  defp headers_to_string(headers) do
    Enum.map(headers, fn {name, value} -> "#{name}: #{value}" end)
    |> Enum.join(", ")
  end

end
