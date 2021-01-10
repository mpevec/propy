defmodule PropyTest do
  use ExUnit.Case
  doctest Propy

  test "greets the world" do
    assert Propy.hello() == :world
  end
end
