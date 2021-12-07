defmodule AOC.Day7a do
  import AOC
  require Integer

  def solution(path) do
    crabs =
      path
      |> read_lines()
      |> List.first()
      |> String.split(",")
      |> Enum.map(&to_int/1)
      |> Enum.sort()

    crabs
    |> median()
    |> calculate_shift(crabs)
  end

  def calculate_shift(n, crabs) do
    crabs
    |> Enum.map(&shift_crab(&1, n))
    |> Enum.sum()
  end

  def shift_crab(crab, n) do
    abs(crab - n)
  end

  def median(crabs) do
    l = length(crabs)

    case Integer.is_odd(l) do
      true -> Enum.at(crabs, div(l, 2))
      false -> div(Enum.at(crabs, div(l, 2) - 1) + Enum.at(crabs, div(l, 2)), 2)
    end
  end
end
