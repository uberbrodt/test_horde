defmodule TestHordeTest do
  use ExUnit.Case
  doctest TestHorde

  test "greets the world" do
    assert TestHorde.hello() == :world
  end
end
