defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line args & dispatch
  to functions
  """

  def run(argv) do
    parse_args(argv)
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
end
