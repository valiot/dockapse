defmodule Dockapse do
  def build(dockerfile, tag, stdio \\ false) do
    docker(["build", "-f", dockerfile, "-t", tag, "."], stdio)
  end

  def cp(cid, source, dest, stdio \\ false) do
    docker(["cp", "#{cid}:#{source}", dest], stdio)
  end

  def ps(ps_args, stdio \\ false)

  def ps(true, stdio) do
    docker(["ps", "-a"], stdio)
  end

  def ps(false, stdio) do
    docker(["ps"], stdio)
  end

  def ps(ps_args, stdio) when is_list(ps_args) do
    docker(["ps"] ++ ps_args, stdio)
  end

  def images(stdio \\ false) do
    docker(["images"], stdio)
  end

  def rmi(image_id, stdio \\ false) do
    docker(["rmi", image_id], stdio)
  end

  def create(image, name, stdio \\ false)

  def create(image, nil, stdio) do
    docker(["create", image], stdio)
  end

  def create(image, name, stdio) do
    docker(["create", "--name", name, image], stdio)
  end

  def tag(image, tag, stdio \\ false) do
    docker(["tag", image, tag], stdio)
  end

  def push(image, stdio \\ false) do
    docker(["push"] ++ [image], stdio)
  end

  def rm(cid, stdio \\ false) do
    docker(["rm", "-f", cid], stdio)
  end

  def run(run_args, stdio \\ false) do
    cond do
      is_daemon?(run_args) ->
        docker_daemon(["run"] ++ run_args, stdio)

      true ->
        docker(["run"] ++ run_args, stdio)
    end
  end

  def cmd(cmd, cmd_args \\ [], stdio \\ false) do
    cond do
      is_daemon?(cmd_args) ->
        docker_daemon([cmd] ++ cmd_args, stdio)

      true ->
        docker([cmd] ++ cmd_args, stdio)
    end
  end

  defp docker(args, stdio) do
    opts = (stdio && [into: IO.stream(:stdio, :line)]) || []
    MuonTrap.cmd("docker", args, opts)
  end

  defp docker_daemon(args, stdio) do
    opts = (stdio && [into: IO.stream(:stdio, :line)]) || []
    daemon_option = [stderr_to_stdout: true, log_output: :debug, log_prefix: "(#{__MODULE__}) "]
    MuonTrap.Daemon.start_link("docker", args, opts ++ daemon_option)
  end

  defp is_daemon?(args), do: "-d" in args or "--detach" in args
end
