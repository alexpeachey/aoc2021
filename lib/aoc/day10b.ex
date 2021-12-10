defmodule AOC.Day10b do
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
    scores =
      path
      |> read_lines()
      |> Enum.map(&check_syntax/1)
      |> Enum.filter(fn
        {:error, _} -> false
        _ -> true
      end)
      |> Enum.map(&score_closers/1)
      |> Enum.sort()

    Enum.at(scores, div(length(scores), 2))
  end

  def calculate_score(p, s), do: s * 5 + p

  def score_closers(line) do
    line
    |> Enum.reverse()
    |> Enum.reduce({[], []}, &complete/2)
    |> elem(1)
    |> Enum.map(&closer_to_points/1)
    |> Enum.reduce(0, &calculate_score/2)
  end

  def complete(char, {[], closers}) when char in @openers,
    do: {[], [@open_close_map[char] | closers]}

  def complete(char, {[char | buff], closers}) when char in @openers,
    do: {buff, closers}

  def complete(char, {buff, closers}) when char in @closers,
    do: {[char | buff], closers}

  def(check_syntax(line)) do
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

  def closer_to_points(")"), do: 1
  def closer_to_points("]"), do: 2
  def closer_to_points("}"), do: 3
  def closer_to_points(">"), do: 4
end
