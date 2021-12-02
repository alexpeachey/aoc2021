defmodule AOC.Day2b do
  import AOC

  def solution(path) do
    path
    |> read_lines()
    |> Enum.map(&String.split/1)
    |> Enum.map(&convert_move/1)
    |> Enum.reduce({0, 0, 0}, &move/2)
    |> Tuple.delete_at(0)
    |> Tuple.product()
  end

  def convert_move([d, n]) do
    {n, _} = Integer.parse(n)
    [d, n]
  end

  def move(["forward", n], {a, h, v}), do: {a, h + n, v + a * n}
  def move(["down", n], {a, h, v}), do: {a + n, h, v}
  def move(["up", n], {a, h, v}), do: {a - n, h, v}
end
