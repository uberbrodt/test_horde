defmodule TestHorde.Registry do
  @moduledoc false

  def start_link do
    Horde.Registry.start_link([name: __MODULE__, keys: :unique])
  end
end
