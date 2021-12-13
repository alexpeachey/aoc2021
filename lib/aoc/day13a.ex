defmodule AOC.Day13a do
  import AOC

  def solution(path) do
    lines =
      path
      |> read_lines()

    dots =
      lines
      |> Enum.reject(&String.starts_with?(&1, "fold along"))
      |> Enum.map(&String.split(&1, ",", trim: true))
      |> Enum.map(fn [x, y] -> {to_int(x), to_int(y)} end)

    folds =
      lines
      |> Enum.filter(&String.starts_with?(&1, "fold along"))
      |> Enum.map(&String.replace_leading(&1, "fold along ", ""))
      |> Enum.map(&String.split(&1, "=", trim: true))
      |> Enum.map(fn [axis, d] -> {axis, to_int(d)} end)

    dots
    |> Enum.map(&fold(&1, List.first(folds)))
    |> Enum.uniq()
    |> Enum.count()
  end

  def fold({x, y}, {"x", index}) when x < index, do: {x, y}
  def fold({x, y}, {"x", index}) when x > index, do: {2 * index - x, y}
  def fold({x, y}, {"y", index}) when y < index, do: {x, y}
  def fold({x, y}, {"y", index}) when y > index, do: {x, 2 * index - y}
end
