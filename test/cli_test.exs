defmodule CliTest do
  use ExUnit.Case

  import ExUnit.CaptureIO
  import Issues.CLI, only: [parse_args: 1, process: 1]

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

  test "prints help text when passed :help" do
    assert Regex.match?(~r/usage/, capture_io(fn ->
      process(:help)
    end))
  end

  test "exits with 0 when passed :help" do
    fun = fn ->
      assert process(:help) == :ok
    end

    capture_io(fun)
  end
end
