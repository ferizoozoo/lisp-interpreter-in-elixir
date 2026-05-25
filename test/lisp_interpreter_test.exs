defmodule LispInterpreterTest do
  use ExUnit.Case
  doctest LispInterpreter

  test "greets the world" do
    assert LispInterpreter.hello() == :world
  end
end
