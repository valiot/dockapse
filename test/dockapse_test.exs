defmodule DockapseTest do
  use ExUnit.Case
  doctest Dockapse

  defp cleanup(container_id: container_id) do
    System.cmd("docker", ["rm", "#{container_id}"])
  end

  defp cleanup(image_id: image_id) do
    System.cmd("docker", ["rmi", "#{image_id}"])
  end

  setup do
    try do
      System.cmd("docker", ["--help"])
      {image_id, _} = System.cmd("docker", ["pull", "alpine"])
      {container_id, _} = System.cmd("docker", ["create", "alpine"])

      {
        :ok,
        %{
          container_id: String.trim(container_id),
          image_id: String.trim(image_id)
        }
      }
    rescue
      ErlangError ->
        IO.puts("""
          Docker is not installed on your machine
        """)

        exit(1)
    end
  end

  test "ps", %{container_id: container_id} do
    IO.inspect(Dockapse.ps(false))
    IO.inspect(Dockapse.ps(true))

    cleanup(container_id: container_id)
  end

  test "cmd (wildcard)" do
    {version_info, 0} = Dockapse.cmd("--version")
    {run_help_info, 0} = Dockapse.cmd("run", ["--help"])
    assert version_info =~ "Docker version"
    assert run_help_info =~ "Run a command in a new container"
  end

  test "run" do
    {run_help_info, 0} = Dockapse.run(["--help"])
    assert run_help_info =~ "Run a command in a new container"

    {run_output, 0} = Dockapse.run(["hello-world"])
    assert run_output =~ "Hello from Docker"
  end
end
