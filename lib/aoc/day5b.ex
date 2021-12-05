defmodule AOC.Day5b do
  import AOC

  def solution(path) do
    lines =
      path
      |> read_lines()
      |> Enum.map(&convert_lines/1)

    maxx =
      lines
      |> Enum.map(fn [{x1, _}, {x2, _}] -> max(x1, x2) end)
      |> Enum.max()

    maxy =
      lines
      |> Enum.map(fn [{_, y1}, {_, y2}] -> max(y1, y2) end)
      |> Enum.max()

    lines
    |> create_map(maxx, maxy)
    |> count_danger()
  end

  def count_danger(map) do
    map
    |> Enum.map(fn row ->
      row
      |> Enum.count(fn c -> c >= 2 end)
    end)
    |> Enum.sum()
  end

  def create_map(lines, maxx, maxy) do
    0..maxy
    |> Enum.map(fn y ->
      0..maxx
      |> Enum.map(fn x ->
        lines
        |> Enum.count(&contains_point(&1, {x, y}))
      end)
    end)
  end

  def contains_point([{x1, y1}, {x1, y2}], {x, y}) do
    x1 == x &&
      y1..y2 |> Enum.member?(y)
  end

  def contains_point([{x1, y1}, {x2, y1}], {x, y}) do
    x1..x2 |> Enum.member?(x) &&
      y1 == y
  end

  def contains_point([{x1, y1}, {x2, y2}], {x, y}) do
    x1..x2 |> Enum.member?(x) &&
      y1..y2 |> Enum.member?(y) &&
      (y - y1) / (y2 - y1) == (x - x1) / (x2 - x1)
  end

  def convert_lines(line) do
    line
    |> String.split(" -> ")
    |> Enum.map(&coord_strings_to_tuples/1)
  end

  def coord_strings_to_tuples(coords) do
    coords
    |> String.split(",")
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(fn {n, _} -> n end)
    |> List.to_tuple()
  end

  def diagnal?([{x, _}, {x, _}]), do: false
  def diagnal?([{_, y}, {_, y}]), do: false
  def diagnal?(_), do: true
end
