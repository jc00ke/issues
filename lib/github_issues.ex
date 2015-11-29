defmodule Issues.GithubIssues do
  @user_agent [ {"User-Agent", "Elixir example from jc00ke"} ]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    issues_url(user, project)
      |> HTTPoison.get(@user_agent)
      |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{status_code: 200, body: body, headers: _}}) do
    Poison.Parser.parse(body)
  end

  def handle_response({:ok, %{status_code: ___, body: body, headers: _}}) do
    { _, parsed } = Poison.Parser.parse(body)
    { :error, parsed["message"] }
  end

  def handle_response({:error, reason}), do: { :error, reason }
end
