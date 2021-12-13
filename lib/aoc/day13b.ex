defmodule AOC.Day13b do
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
    |> fold(folds)
    |> plot()
  end

  def plot(dots) do
    maxx = dots |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    maxy = dots |> Enum.map(fn {_, y} -> y end) |> Enum.max()

    for y <- 0..maxy do
      for x <- 0..maxx do
        if Enum.member?(dots, {x, y}) do
          IO.write("#")
        else
          IO.write(".")
        end
      end

      IO.write("\n")
    end
  end

  def fold(dots, []), do: dots

  def fold(dots, [instruction | folds]) do
    dots
    |> Enum.map(&fold(&1, instruction))
    |> Enum.uniq()
    |> fold(folds)
  end

  def fold(instruction, dots) when is_list(dots) do
    dots
    |> Enum.map(&fold(&1, instruction))
    |> Enum.uniq()
  end

  def fold({x, y}, {"x", index}) when x < index, do: {x, y}
  def fold({x, y}, {"x", index}) when x > index, do: {2 * index - x, y}
  def fold({x, y}, {"y", index}) when y < index, do: {x, y}
  def fold({x, y}, {"y", index}) when y > index, do: {x, 2 * index - y}
end
