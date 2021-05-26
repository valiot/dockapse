defmodule Dockapse.Engine do
  @moduledoc """
  Handles the persistent process that manages containers, aka dockerd.
  """
  use GenServer
  require Logger

  defstruct engine_args: nil,
            port: nil

  def start_link(engine_opts \\ from_env(), otp_opts \\ [name: __MODULE__]) do
    GenServer.start_link(__MODULE__, engine_opts, otp_opts)
  end

  def init(engine_opts) do
    Logger.info("(#{__MODULE__}) Initializing Docker Engine (dockerd)...")
    {:ok, %__MODULE__{engine_args: engine_opts.args}, {:continue, engine_opts.required_dir}}
  end

  def handle_continue(required_dir, %{engine_args: engine_args} = state) do
    with  :ok <- set_required_dir(required_dir),
          args <- build_dockerd_args(engine_args),
          port_opt <- [stderr_to_stdout: true, log_output: :debug, log_prefix: "(#{__MODULE__}) "],
          exec = get_executable(),
          port = MuonTrap.Daemon.start_link(exec, args, port_opt) do
      {:noreply, %{state | port: port}}
    else
      error -> 
        Logger.warn("(#{__MODULE__}) Unable to start the Engine: #{inspect(error)}.")    
        {:noreply, state}
    end
  end

  def handle_info({_port, {:data, data}}, state) do
    Logger.debug("(#{__MODULE__}) data: #{inspect(data)}.")
    {:noreply, state}
  end

  def handle_info({_port, {:exit_status, code}}, state) do
    Logger.warn("(#{__MODULE__}) Error code: #{inspect(code)}.")
    # retrying delay
    Process.sleep(6000)
    {:stop, :restart, state}
  end

  def handle_info({:EXIT, _port, reason}, state) do
    Logger.debug("(#{__MODULE__}) Exit reason: #{inspect(reason)}")
    # retrying delay
    Process.sleep(6000)
    {:stop, :restart, state}
  end

  def handle_info(msg, state) do
    Logger.debug("(#{__MODULE__}) Unexpected msg: #{inspect(msg)}")
    {:noreply, state}
  end

  defp from_env(), do: Application.get_all_env(:dockapse)

  defp get_executable(), do: System.find_executable("dockerd")

  defp set_required_dir(directory) do
    File.exists?(directory)
    |> create_required_dir(directory)
  end

  defp create_required_dir(true = _dir_exist, _directory), do: :ok
  defp create_required_dir(_dir_does_not_exist, directory) do
    # retrying delay
    Process.sleep(1000)
    Logger.debug("(#{__MODULE__}) Creating Dir: #{directory}")
    File.mkdir_p(directory)
    set_required_dir(directory)
  end
  
  defp build_dockerd_args(engine_args) do
    Enum.reduce(engine_args, [], 
      fn 
        {option_name, ""}, acc -> acc ++ ["#{option_name}"]
        {option_name, value}, acc ->  acc ++ ["#{option_name}=#{value}"]
      end)
  end
end
