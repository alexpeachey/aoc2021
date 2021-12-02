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
end
