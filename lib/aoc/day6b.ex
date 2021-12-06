defmodule AOC.Day6b do
  import AOC

  def solution(path) do
    path
    |> read_lines()
    |> List.first()
    |> String.split(",")
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.frequencies()
    |> simulate_days(256)
    |> Map.values()
    |> Enum.sum()
  end

  def simulate_days(fish, 0), do: fish

  def simulate_days(fish, n) do
    fish
    |> Enum.map(&age_fish/1)
    |> Enum.reduce(%{}, &merge_population/2)
    |> simulate_days(n - 1)
  end

  def age_fish({0, p}), do: %{6 => p, 8 => p}
  def age_fish({n, p}), do: %{(n - 1) => p}

  def merge_population(map, population) do
    population
    |> Map.merge(map, fn _k, v1, v2 -> v1 + v2 end)
  end
end
