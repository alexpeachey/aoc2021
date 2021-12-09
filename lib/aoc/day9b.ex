defmodule AOC.Day9b do
  import AOC

  def solution(path) do
    cells =
      path
      |> read_lines()
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(&Enum.map(&1, fn c -> to_int(c) end))
      |> create_records()
      |> List.flatten()
      |> Enum.into(%{})

    cells =
      cells
      |> Enum.map(&mark_low_points(&1, cells))
      |> Enum.into(%{})

    cells
    |> Enum.map(&mark_basins(&1, cells))
    |> Enum.map(fn {_id, cell} -> cell.basin end)
    |> Enum.reject(fn id -> id == nil end)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.product()
  end

  def mark_basins({id, %{low_point: true} = cell}, _cells) do
    {id,
     %{
       cell
       | basin: cell.id
     }}
  end

  def mark_basins({id, %{value: 9} = cell}, _cells) do
    {id,
     %{
       cell
       | basin: nil
     }}
  end

  def mark_basins({id, cell}, cells) do
    {id,
     %{
       cell
       | basin: find_basin(cell.id, cells)
     }}
  end

  def find_basin(id, cells) do
    next =
      cells[id].neighbors
      |> Enum.filter(fn c -> cells[c].value < cells[id].value end)
      |> Enum.sort_by(fn c -> cells[c].value end)
      |> List.first()

    if cells[next].low_point do
      next
    else
      find_basin(next, cells)
    end
  end

  def mark_low_points({id, cell}, cells) do
    is_low_point =
      cell.neighbors
      |> Enum.map(fn c -> cells[c].value end)
      |> Enum.min()
      |> Kernel.>(cell.value)

    {id,
     %{
       cell
       | low_point: is_low_point
     }}
  end

  def create_records(grid) do
    width = length(List.first(grid)) - 1
    height = length(grid) - 1

    for h <- 0..height,
        w <- 0..width,
        do:
          {{w, h},
           %{
             id: {w, h},
             value: Enum.at(Enum.at(grid, h), w),
             neighbors: find_neighbors(w, h, width, height),
             low_point: false,
             basin: nil
           }}
  end

  def find_neighbors(0, 0, _width, _height), do: [{0, 1}, {1, 0}]
  def find_neighbors(width, 0, width, _height), do: [{width, 1}, {width - 1, 0}]
  def find_neighbors(0, height, _width, height), do: [{0, height - 1}, {1, height}]
  def find_neighbors(width, height, width, height), do: [{width - 1, height}, {width, height - 1}]
  def find_neighbors(0, h, _width, _height), do: [{0, h - 1}, {0, h + 1}, {1, h}]
  def find_neighbors(w, 0, _width, _height), do: [{w - 1, 0}, {w + 1, 0}, {w, 1}]

  def find_neighbors(width, h, width, _height),
    do: [{width, h - 1}, {width, h + 1}, {width - 1, h}]

  def find_neighbors(w, height, _width, height),
    do: [{w - 1, height}, {w + 1, height}, {w, height - 1}]

  def find_neighbors(w, h, _width, _height), do: [{w - 1, h}, {w + 1, h}, {w, h - 1}, {w, h + 1}]
end
