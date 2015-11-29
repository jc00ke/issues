defmodule GithubIssuesTest do
  use ExUnit.Case
  import Mock
  import Issues.GithubIssues

  test_with_mock  "when result is ok",
                  HTTPoison,
                  [get: fn(_url, _headers) ->
                    {:ok, %{status_code: 200, body: "success", headers: []}}
                  end] do
                    user = "jc00ke"
                    project = "issues"

                    assert fetch(user, project) == { :ok, "success" }
                    assert called HTTPoison.get(issues_url(user, project), :_)
                  end

  test_with_mock  "when result is not ok",
                  HTTPoison,
                  [get: fn(_url, _headers) ->
                      {:ok, %{status_code: 500, body: "unsuccessful", headers: []}}
                  end] do
                    user = "jc00ke"
                    project = "issues"

                    assert fetch(user, project) == { :error, "unsuccessful" }
                    assert called HTTPoison.get(issues_url(user, project), :_)
                  end

  test "returns the API url" do
    assert issues_url("jc00ke", "issues") == "https://api.github.com/repos/jc00ke/issues/issues"
  end

  test "handle response when status code is 200" do
    assert handle_response({:ok, %{status_code: 200, body: "body", headers: []}}) == { :ok, "body" }
  end

  test "handle response when other status code is returned" do
    assert handle_response({:ok, %{status_code: 500, body: "body", headers: []}}) == { :error, "body" }
  end

  test "handle response when error occurs" do
    assert handle_response({:error, 42}) == { :error, 42 }
  end
end
