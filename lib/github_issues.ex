defmodule Issues.GithubIssues do
  @user_agent [ {"User-Agent", "Elixir example from jc00ke"} ]

  def fetch(user, project) do
    issues_url(user, project)
      |> HTTPoison.get(@user_agent)
      |> handle_response
  end

  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{status_code: 200, body: body, headers: _}}) do
    { :ok, body }
  end

  def handle_response({:ok, %{status_code: ___, body: body, headers: _}}) do
    { :error, body }
  end

  def handle_response({:error, reason}), do: { :error, reason }
end
