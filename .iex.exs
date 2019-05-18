Node.ping(:"test-horde-1@127.0.0.1")
Node.ping(:"test-horde-2@127.0.0.1")


defmodule IEXTesting do
  def list_registry do
    Horde.Registry.processes(TestHorde.Registry)
  end
end
