defmodule CliTest do
  use ExUnit.Case, async: false
  import Mock

  import ExUnit.CaptureIO
  import Issues.CLI

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
    ~r/usage/
      |> Regex.match?(capture_io(fn -> process(:help) end))
      |> assert
  end

  test "exits with 0 when passed :help" do
    fun = fn ->
      assert catch_exit(process(:help)) == 0
    end

    capture_io(fun)
  end

  test_with_mock  "calls GithubIssues.fetch when given a tuple",
                  Issues.GithubIssues,
                  [fetch: fn(_user, _project) -> :ok end] do
    user = "jc00ke"
    project = "issues"
    process({user, project, 16})
    assert called Issues.GithubIssues.fetch(user, project)
  end

  test "exits with non-zero when error returned" do
    fun = fn ->
      assert catch_exit(decode_response({:error, "msg"})) != 0
    end

    capture_io(:stderr, fun)
  end

  test_with_mock  "prints error message when error returned",
                  Issues.CLI,
                  [halt: fn(_status) -> :ok end] do
    captured = capture_io(:stderr, fn -> decode_response({:error, "elephant"}) end)
    ~r/elephant/
      |> Regex.match?(captured)
      |> assert
    assert called Issues.CLI.halt(2)
  end
end
