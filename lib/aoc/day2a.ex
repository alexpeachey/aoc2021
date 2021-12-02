defmodule AOC.Day2a do
  import AOC

  def solution(path) do
    path
    |> read_lines()
    |> Enum.map(&String.split/1)
    |> Enum.map(&convert_move/1)
    |> Enum.reduce({0, 0}, &move/2)
    |> Tuple.product()
  end

  def convert_move([d, n]) do
    {n, _} = Integer.parse(n)
    [d, n]
  end

  def move(["forward", n], {h, v}), do: {h + n, v}
  def move(["down", n], {h, v}), do: {h, v + n}
  def move(["up", n], {h, v}), do: {h, v - n}
end
