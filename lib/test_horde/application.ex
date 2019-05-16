defmodule TestHorde.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Horde.Registry, [name: TestHorde.Registry, keys: :unique]},
      {TestHorde.Supervisor, [name: TestHorde.Supervisor, strategy: :one_for_one]},
      {TestHorde.HordeLinker,
       [
         name: HordeLinker,
         supervisor_name: TestHorde.Supervisor,
         callback: fn -> TestHorde.start_workers(10) end
       ]},
      {TestHorde.HordeLinker, [name: HordeRegistryLinker, supervisor_name: TestHorde.Registry]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TestHorde.AppSupervisor]
    Supervisor.start_link(children, opts)
  end
end
