defmodule GithubIssuesTest do
  use ExUnit.Case
  import Mock
  import Issues.GithubIssues

  test_with_mock  "when status code is 200",
                  HTTPoison,
                  [get: fn(_url, _headers) ->
                    {:ok, %{status_code: 200, body: "{}", headers: []}}
                  end] do
                    user = "jc00ke"
                    project = "issues"

                    assert fetch(user, project) == { :ok, %{} }
                    assert called HTTPoison.get(issues_url(user, project), :_)
                  end

  test_with_mock  "when result is ok but status code not 200",
                  HTTPoison,
                  [get: fn(_url, _headers) ->
                    { _, body } = Poison.encode(%{ message: "err" })
                    {:ok, %{status_code: 500, body: body, headers: []}}
                  end] do
                    user = "jc00ke"
                    project = "issues"

                    assert fetch(user, project) == { :error, "err" }
                    assert called HTTPoison.get(issues_url(user, project), :_)
                  end

  test_with_mock  "when result is not ok",
                  HTTPoison,
                  [get: fn(_url, _headers) ->
                      {:error, "reason"}
                  end] do
                    user = "jc00ke"
                    project = "issues"

                    assert fetch(user, project) == { :error, "reason" }
                    assert called HTTPoison.get(issues_url(user, project), :_)
                  end

  test "returns the API url" do
    assert issues_url("jc00ke", "issues") == "https://api.github.com/repos/jc00ke/issues/issues"
  end

  test "handle response when status code is 200" do
    assert handle_response({:ok, %{status_code: 200, body: "{}", headers: []}}) == { :ok, %{} }
  end

  test "handle response when status code isn't 200" do
    assert handle_response({:ok, %{status_code: 404, body: "{ \"message\": \"err\"}", headers: []}}) == { :error, "err" }
  end

  test "handle response when error occurs" do
    assert handle_response({:error, 42}) == { :error, 42 }
  end
end
