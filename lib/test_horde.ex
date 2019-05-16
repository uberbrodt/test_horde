defmodule TestHorde do
  @moduledoc """
  Documentation for TestHorde.
  """

  def start_worker(name) do
    name = {:via, Horde.Registry, {TestHorde.Registry, name}}

    spec =
      Supervisor.child_spec({TestHorde.TestGenServer, [name: name]}, id: {TestGenServer, name})

    Horde.Supervisor.start_child(TestHorde.Supervisor, spec)
  end

  def start_workers(count) do
    for i <- 0..count do
      name = {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_#{i}"}}

      spec =
        Supervisor.child_spec({TestHorde.TestGenServer, [name: name]}, id: {TestGenServer, name})

      Horde.Supervisor.start_child(TestHorde.Supervisor, spec)
    end
  end
end
