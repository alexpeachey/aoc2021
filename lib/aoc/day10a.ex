defmodule AOC.Day10a do
  import AOC

  @openers ["(", "[", "{", "<"]
  @closers [")", "]", "}", ">"]
  @open_close_map %{
    "(" => ")",
    "[" => "]",
    "{" => "}",
    "<" => ">"
  }

  def solution(path) do
    path
    |> read_lines()
    |> Enum.map(&check_syntax/1)
    |> Enum.filter(fn
      {:error, _} -> true
      _ -> false
    end)
    |> Enum.map(&error_to_points/1)
    |> Enum.sum()
  end

  def check_syntax(line) do
    line
    |> String.split("", trim: true)
    |> Enum.reduce([], &consume/2)
  end

  def consume(_, {:error, _} = error), do: error
  def consume(char, buff) when char in @openers, do: [char | buff]

  def consume(char, [opener | buff]) when char in @closers do
    if @open_close_map[opener] == char do
      buff
    else
      {:error, char}
    end
  end

  def error_to_points({:error, ")"}), do: 3
  def error_to_points({:error, "]"}), do: 57
  def error_to_points({:error, "}"}), do: 1197
  def error_to_points({:error, ">"}), do: 25137
end
