defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line args & dispatch
  to functions
  """

  def run(argv) do
    argv
      |> parse_args
      |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it's user, project, [count]

  Return a tuple `{ user, project, count }`, or :help if `help`
  was given
  """

  def parse_args(argv) do
    parser = OptionParser.parse(argv,
                                switches: [help: :boolean],
                                aliases: [h: :help])

    case parser do
      {[:help, true], _, _}
        -> :help

      {_, [user, project, count], _}
        -> {user, project, String.to_integer(count)}

      {_, [user, project],  _}
        -> {user, project, @default_count}

      _ ->
        :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [count | #{@default_count}]"
    """

    System.halt(0)
  end

  def process({user, project, _count}) do
    Issues.GithubIssues.fetch(user, project)
  end

  def decode_response({:error, message}) do
    IO.write :stderr, message

    halt(2)
  end

  def halt(status \\ 0) do
    System.halt(status)
  end
end
