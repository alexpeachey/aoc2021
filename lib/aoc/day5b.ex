defmodule AOC.Day5b do
  import AOC

  def solution(path) do
    path
    |> read_lines()
    |> Enum.map(&convert_lines/1)
    |> Enum.flat_map(&explode_to_points/1)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.count(fn n -> n >= 2 end)
  end

  def explode_to_points([{x, y1}, {x, y2}]) do
    y1..y2
    |> Enum.map(fn y -> {x, y} end)
  end

  def explode_to_points([{x1, y}, {x2, y}]) do
    x1..x2
    |> Enum.map(fn x -> {x, y} end)
  end

  def explode_to_points([{x1, y1}, {x2, y2}]) do
    dx = if x1 < x2, do: 1, else: -1
    dy = if y1 < y2, do: 1, else: -1
    [{x1, y1} | explode_to_points([{x1 + dx, y1 + dy}, {x2, y2}])]
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
