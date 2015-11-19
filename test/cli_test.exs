defmodule CliTest do
  use ExUnit.Case

  import Issues.CLI, only: [parse_args: 1 ]

  test ":help returned when passed -h" do
    assert parse_args(["-h", "asdf"]) == :help
  end

  test ":help returned when passed --help" do
    assert parse_args(["--help", "asdf"]) == :help
  end

  test "3 values returned when 3 given" do
    assert parse_args(["a", "b", "42"]) == {"a", "b", 42}
  end

  test "default count returned when 2 given" do
    assert parse_args(["a", "b"]) == {"a", "b", 4}
  end
end
