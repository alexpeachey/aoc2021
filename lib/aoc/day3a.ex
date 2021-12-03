defmodule AOC.Day3a do
  import AOC

  def solution(path) do
    frequencies = generate_frequencies(path)

    generate_gamma(frequencies) *
      generate_epsilon(frequencies)
  end

  def generate_frequencies(path) do
    path
    |> read_lines()
    |> Enum.map(&String.split(&1, "", trim: true))
    |> transpose()
    |> Enum.map(&Enum.frequencies/1)
  end

  def generate_gamma(frequencies) do
    frequencies
    |> Enum.map(&find_gamma/1)
    |> binary_to_int()
  end

  def generate_epsilon(frequencies) do
    frequencies
    |> Enum.map(&find_epsilon/1)
    |> binary_to_int()
  end

  def find_gamma(%{"0" => x, "1" => y}) when x < y, do: "1"
  def find_gamma(%{"0" => x, "1" => y}) when x > y, do: "0"
  def find_gamma(%{"0" => _}), do: "0"
  def find_gamma(%{"1" => _}), do: "1"

  def find_epsilon(%{"0" => x, "1" => y}) when x < y, do: "0"
  def find_epsilon(%{"0" => x, "1" => y}) when x > y, do: "1"
  def find_epsilon(%{"0" => _}), do: "0"
  def find_epsilon(%{"1" => _}), do: "1"

  def transpose(list) do
    list
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def binary_to_int(bits) do
    bits
    |> Enum.join("")
    |> Integer.parse(2)
    |> elem(0)
  end
end
