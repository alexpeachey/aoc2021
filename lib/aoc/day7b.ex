defmodule AOC.Day7b do
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

    min_crab = Enum.min(crabs)
    max_crab = Enum.max(crabs)

    min_crab..max_crab
    |> Enum.map(&sum_crab_shifts(&1, crabs))
    |> Enum.min()
  end

  def sum_crab_shifts(n, crabs) do
    crabs
    |> Enum.map(&shift_crab(&1, n))
    |> Enum.sum()
  end

  def shift_crab(crab, n) do
    moves = abs(crab - n)
    round(moves / 2 * (moves + 1))
  end
end
