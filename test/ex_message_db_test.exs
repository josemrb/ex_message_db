defmodule ExMessageDbTest do
  use ExUnit.Case
  doctest ExMessageDb

  test "greets the world" do
    assert ExMessageDb.hello() == :world
  end
end
