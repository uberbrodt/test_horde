defmodule TestHorde.TestGenServer do
  @moduledoc false
  use GenServer, restart: :permanent
  require Logger

  def start_link(args) do
    IO.inspect(args, label: "TestGenServer args")
    GenServer.start_link(__MODULE__, args, name: args[:name])
  end

  @impl GenServer
  def init(args) do
    state = args
    {:ok, state}
  end

  def call_and_exit(reason) do
    GenServer.call(__MODULE__, {:call_and_exit, reason})
  end

  @impl GenServer
  def handle_call({:call_and_exit, reason}, _from, state) do
    Logger.warn("Got the call! Now exiting")
    {:stop, reason, :ok, state}
  end
end
