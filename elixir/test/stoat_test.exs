defmodule StoatTest do
  use ExUnit.Case
  doctest Stoat

  test "greets the world" do
    assert Stoat.hello() == :world
  end
end
