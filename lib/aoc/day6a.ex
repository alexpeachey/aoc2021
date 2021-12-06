defmodule AOC.Day6a do
  import AOC

  def solution(path) do
    path
    |> read_lines()
    |> List.first()
    |> String.split(",")
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
    |> simulate_days(80)
    |> Enum.count()
  end

  def simulate_days(fish, 0), do: fish

  def simulate_days(fish, n) do
    fish
    |> Enum.flat_map(&age_fish/1)
    |> simulate_days(n - 1)
  end

  def age_fish(0), do: [6, 8]
  def age_fish(n), do: [n - 1]
end
