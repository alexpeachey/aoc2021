defmodule AOC.Day3b do
  import AOC

  def solution(path) do
    bits = generate_bits(path)
    o2 = determine_reading(bits, &generate_gamma/1, 1)
    co2 = determine_reading(bits, &generate_epsilon/1, 1)
    o2 * co2
  end

  def determine_reading(bits, mask_fn, mask_lenth) do
    frequencies = generate_frequencies(bits)

    mask =
      frequencies
      |> mask_fn.()
      |> Enum.take(mask_lenth)

    matches = find_matches(bits, mask)

    if length(matches) == 1 do
      matches
      |> hd()
      |> binary_to_int()
    else
      determine_reading(matches, mask_fn, mask_lenth + 1)
    end
  end

  def find_matches(bits, mask) do
    bits
    |> Enum.filter(&mask_match?(Enum.join(&1), mask))
  end

  def mask_match?(n, mask) do
    String.starts_with?(n, Enum.join(mask, ""))
  end

  def generate_bits(path) do
    path
    |> read_lines()
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def generate_frequencies(bits) do
    bits
    |> transpose()
    |> Enum.map(&Enum.frequencies/1)
  end

  def generate_gamma(frequencies) do
    frequencies
    |> Enum.map(&find_gamma/1)
  end

  def generate_epsilon(frequencies) do
    frequencies
    |> Enum.map(&find_epsilon/1)
  end

  def find_gamma(%{"0" => x, "1" => y}) when x < y, do: "1"
  def find_gamma(%{"0" => x, "1" => y}) when x > y, do: "0"
  def find_gamma(%{"0" => x, "1" => y}) when x == y, do: "1"
  def find_gamma(%{"0" => _}), do: "0"
  def find_gamma(%{"1" => _}), do: "1"

  def find_epsilon(%{"0" => x, "1" => y}) when x < y, do: "0"
  def find_epsilon(%{"0" => x, "1" => y}) when x > y, do: "1"
  def find_epsilon(%{"0" => x, "1" => y}) when x == y, do: "0"
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
