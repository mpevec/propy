defmodule PropyCoreTest do
  use ExUnit.Case
  doctest PropyCore

  test "greets the world" do
    assert PropyCore.hello() == :world
  end
end
