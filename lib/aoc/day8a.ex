defmodule AOC.Day8a do
  import AOC

  def solution(path) do
    path
    |> read_lines()
    |> Enum.map(&String.split(&1, " | "))
    |> Enum.map(&List.last/1)
    |> Enum.map(&String.split/1)
    |> Enum.flat_map(&Enum.filter(&1, fn d -> easy_digit(d) end))
    |> Enum.count()
  end

  def easy_digit(d) when byte_size(d) == 2, do: true
  def easy_digit(d) when byte_size(d) == 3, do: true
  def easy_digit(d) when byte_size(d) == 4, do: true
  def easy_digit(d) when byte_size(d) == 7, do: true
  def easy_digit(_), do: false
end
