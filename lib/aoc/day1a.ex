defmodule AOC.Day1a do
  import AOC

  def solution(path) do
    path
    |> read_lines()
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce({0, nil}, &count_increases/2)
    |> elem(0)
  end

  def count_increases(n, {0, nil}), do: {0, n}
  def count_increases(n, {c, p}) when p < n, do: {c + 1, n}
  def count_increases(n, {c, _}), do: {c, n}
end
