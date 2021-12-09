defmodule AOC.Day9a do
  import AOC

  def solution(path) do
    path
    |> read_lines()
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(&Enum.map(&1, fn c -> to_int(c) end))
    |> find_neighbors()
    |> List.flatten()
    |> Enum.filter(&low_point/1)
    |> Enum.map(fn {n, _} -> n + 1 end)
    |> Enum.sum()
  end

  def low_point({n, neighbors}) do
    n < Enum.min(neighbors)
  end

  def find_neighbors(grid) do
    width = length(List.first(grid)) - 1
    height = length(grid) - 1

    for h <- 0..height,
        w <- 0..width,
        do: {Enum.at(Enum.at(grid, h), w), find_neighbors(w, h, grid, width, height)}
  end

  def find_neighbors(0, 0, grid, _width, _height) do
    [Enum.at(Enum.at(grid, 0), 1), Enum.at(Enum.at(grid, 1), 0)]
  end

  def find_neighbors(width, 0, grid, width, _height) do
    [Enum.at(Enum.at(grid, 0), width - 1), Enum.at(Enum.at(grid, 1), width)]
  end

  def find_neighbors(0, height, grid, _width, height) do
    [Enum.at(Enum.at(grid, height - 1), 0), Enum.at(Enum.at(grid, height), 1)]
  end

  def find_neighbors(width, height, grid, width, height) do
    [Enum.at(Enum.at(grid, height - 1), width), Enum.at(Enum.at(grid, height), width - 1)]
  end

  def find_neighbors(0, h, grid, _width, _height) do
    [
      Enum.at(Enum.at(grid, h - 1), 0),
      Enum.at(Enum.at(grid, h + 1), 0),
      Enum.at(Enum.at(grid, h), 1)
    ]
  end

  def find_neighbors(w, 0, grid, _width, _height) do
    [
      Enum.at(Enum.at(grid, 0), w - 1),
      Enum.at(Enum.at(grid, 0), w + 1),
      Enum.at(Enum.at(grid, 1), w)
    ]
  end

  def find_neighbors(width, h, grid, width, _height) do
    [
      Enum.at(Enum.at(grid, h - 1), width),
      Enum.at(Enum.at(grid, h + 1), width),
      Enum.at(Enum.at(grid, h), width - 1)
    ]
  end

  def find_neighbors(w, height, grid, _width, height) do
    [
      Enum.at(Enum.at(grid, height), w - 1),
      Enum.at(Enum.at(grid, height), w + 1),
      Enum.at(Enum.at(grid, height - 1), w)
    ]
  end

  def find_neighbors(w, h, grid, _width, _height) do
    [
      Enum.at(Enum.at(grid, h - 1), w),
      Enum.at(Enum.at(grid, h + 1), w),
      Enum.at(Enum.at(grid, h), w - 1),
      Enum.at(Enum.at(grid, h), w + 1)
    ]
  end
end
