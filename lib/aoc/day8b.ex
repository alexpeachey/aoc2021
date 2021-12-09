defmodule AOC.Day8b do
  import AOC

  @coded0 "abcefg"
  @coded1 "cf"
  @coded2 "acdeg"
  @coded3 "acdfg"
  @coded4 "bcdf"
  @coded5 "abdfg"
  @coded6 "abdefg"
  @coded7 "acf"
  @coded8 "abcdefg"
  @coded9 "abcdfg"

  def solution(path) do
    path
    |> read_lines()
    |> Enum.map(&String.split(&1, " | "))
    |> Enum.map(&decode/1)
  end

  def decode([inputs, outputs]) do
    inputs =
      inputs
      |> String.split()

    a = find_a(inputs)
    g = find_g(inputs, a)
    e = find_e(inputs, a, g)
    d = find_d(inputs, a, e, g)
    b = find_b(inputs, a, d, e, g)

    IO.inspect({a, g, e, d, b})

    # outputs =
    #   outputs
    #   |> String.split()
  end

  def find_b(digits, a, d, e, g) do
    one = Enum.find(digits, &is_1?/1)
    four = Enum.find(digits, &is_4?/1)
    mask = letters(one) ++ [a, d, e, g]

    (letters(four) -- mask)
    |> List.first()
  end

  def find_d(digits, a, e, g) do
    one = Enum.find(digits, &is_1?/1)
    four = Enum.find(digits, &is_4?/1)
    mask = [a | letters(four)]

    three_or_nine =
      digits
      |> Enum.find(fn d -> length(letters(d) -- mask) == 1 end)
      |> letters()

    mask = letters(one) ++ [a, e, g]

    (three_or_nine -- mask)
    |> List.first()
  end

  def find_e(digits, a, g) do
    four = Enum.find(digits, &is_4?/1)
    eight = Enum.find(digits, &is_8?/1)
    mask = [a, g] ++ letters(four)

    (letters(eight) -- mask)
    |> List.first()
  end

  def find_g(digits, a) do
    four = Enum.find(digits, &is_4?/1)
    mask = [a | letters(four)]

    three_or_nine =
      digits
      |> Enum.find(fn d -> length(letters(d) -- mask) == 1 end)
      |> letters()

    (three_or_nine -- mask)
    |> List.first()
  end

  def find_a(digits) do
    one = Enum.find(digits, &is_1?/1)
    seven = Enum.find(digits, &is_7?/1)

    (letters(seven) -- letters(one))
    |> List.first()
  end

  def is_1?(d) when byte_size(d) == 2, do: true
  def is_1?(_), do: false
  def is_4?(d) when byte_size(d) == 4, do: true
  def is_4?(_), do: false
  def is_7?(d) when byte_size(d) == 3, do: true
  def is_7?(_), do: false
  def is_8?(d) when byte_size(d) == 7, do: true
  def is_8?(_), do: false

  def easy_digit(d) when byte_size(d) == 2, do: true
  def easy_digit(d) when byte_size(d) == 3, do: true
  def easy_digit(d) when byte_size(d) == 4, do: true
  def easy_digit(d) when byte_size(d) == 7, do: true
  def easy_digit(_), do: false

  def letters(digit), do: String.split(digit, "", trim: true)
end
