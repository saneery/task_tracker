defmodule SchemaRegistryTest do
  use ExUnit.Case
  doctest SchemaRegistry

  test "greets the world" do
    assert SchemaRegistry.hello() == :world
  end
end
