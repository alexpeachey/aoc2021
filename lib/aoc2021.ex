defmodule AOC do
  @moduledoc """
  Documentation for `AOC`.
  """

  def read_lines(path) do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.reject(fn l -> l == "" end)
  end

  def to_int(str) do
    str
    |> Integer.parse()
    |> elem(0)
  end
end
