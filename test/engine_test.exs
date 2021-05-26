defmodule EngineTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureLog
  alias Dockapse.Engine
  doctest Dockapse

  test "start Docker Engine (dockerd)" do
    dockerd_args = %{
      args: %{},
      required_dir: "./"
    }

    logs =
      capture_log(fn ->
        Engine.start(dockerd_args)
        Process.sleep(1000)
      end)

    IO.puts(logs)

    assert logs =~ "Initializing Docker Engine (dockerd)..."
    assert logs =~ "msg=\"Starting up\""
  end

  test "Engine creates de required directory" do
    File.rmdir("./tmp")

    dockerd_args = %{
      args: %{},
      required_dir: "./tmp"
    }

    logs =
      capture_log(fn ->
        Engine.start(dockerd_args)
        Process.sleep(2000)
      end)

    IO.puts(logs)

    assert logs =~ "Initializing Docker Engine (dockerd)..."
    assert logs =~ "msg=\"Starting up\""
    assert logs =~ "Creating Dir: ./tmp"

    assert File.exists?("./tmp")
    File.rmdir("./tmp")
  end
end
