defmodule LogHeadersTest do
  use ExUnit.Case
  use Plug.Test

  import ExUnit.CaptureLog

  defmodule TestApp do
    use Plug.Router

    plug :match
    plug :dispatch
    plug LogHeaders

    get "/" do
      send_resp(conn, 200, "")
    end

  end

  @opts TestApp.init([])

  test "logs headers to console" do
    console = capture_log(fn -> call() end)
    assert console == ""
  end

  test "logs header to console" do
    console = capture_log(fn -> call([{"header", "value"}]) end)
    assert Regex.match? ~r/\[info\]  header: value/u, console
  end

  test "logs multiple headers to console" do
    console = capture_log(fn -> call([{"header-a", "value-a"}, {"header-b", "value-b"}]) end)
    assert Regex.match? ~r/\[info\]  header-a: value-a, header-b: value-b/u, console
  end

  defp call(), do: conn(:get, "/") |> TestApp.call(@opts)

  defp call(headers) do
    Enum.reduce(headers, conn(:get, "/"), &(add_header(&2, &1)))
    |> TestApp.call(@opts)
  end

  defp add_header(conn, {name, value}), do: conn |> put_req_header(name, value)

end
