defmodule TestHorde.HordeLinker do
  @moduledoc """
  A server that will connect a `Horde.Supervisor` to other horde supervisors on different nodes
  """
  use GenServer
  require Logger

  def child_spec(args) do
    %{
      id: args[:name],
      start: {__MODULE__, :start_link, [args]}
    }
  end

  def start_link(args) do
    name = args[:name]
    GenServer.start_link(__MODULE__, args, name: name)
  end

  @impl GenServer
  def init(args) do
    :net_kernel.monitor_nodes(true)

    callback = Keyword.get(args, :callback, fn -> :ok end)
    supervisor_name = args[:supervisor_name]

    unless is_atom(supervisor_name),
      do: raise(ArgumentError, message: ":supervisor_name must be an atom")

    unless is_function(callback, 0),
      do: raise(ArgumentError, message: ":callback must be an 0-arity function")

    sync_interval = Keyword.get(args, :sync_interval, 60_000)

    connect_hordes(supervisor_name)
    Process.send_after(self(), :connect_hordes, sync_interval)
    callback.()
    {:ok, %{sync_interval: sync_interval, supervisor_name: supervisor_name, callback: callback}}
  end

  @impl GenServer
  def handle_info({:nodeup, node}, %{supervisor_name: sup} = state) do
    Logger.debug(fn -> "Received :nodeup message from #{inspect(node)}" end)
    connect_hordes(sup)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:nodedown, node}, state) do
    Logger.debug(fn -> "Received :nodedown message from #{inspect(node)}" end)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info(
        :connect_hordes,
        %{sync_interval: si, supervisor_name: sup, callback: cb} = state
      ) do
    Process.send_after(self(), :connect_hordes, si)
    :ok = connect_hordes(sup)
    cb.()
    {:noreply, state}
  end

  def connect_hordes(sup) do
    members = (Node.list() ++ [Node.self()]) |> Enum.map(fn n -> {sup, n} end)

    cluster_members = Horde.Cluster.members(sup)

    unless members == cluster_members, do: Horde.Cluster.set_members(sup, members)
  end
end
