defmodule PropyWebTest do
  use ExUnit.Case
  doctest PropyWeb

  test "greets the world" do
    assert PropyWeb.hello() == :world
  end
end
