defmodule TestHorde.Supervisor do
  @moduledoc false
  use Horde.Supervisor

  def start_link do
    Horde.Supervisor.start_link([name: __MODULE__, strategy: :one_for_one, max_restart: 20,
      max_seconds: 5 ])
  end

  def init(opts) do
    {:ok, opts}
  end
end
