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
    |> Enum.sum()
  end

  def decode([inputs, outputs]) do
    inputs = String.split(inputs, " ", trim: true)

    a = find_a(inputs)
    g = find_g(inputs, a)
    e = find_e(inputs, a, g)
    d = find_d(inputs, a, e, g)
    b = find_b(inputs, a, d, e, g)
    c = find_c(inputs, a, b, d, e, g)
    f = find_f(inputs, a, b, c, d, e, g)

    mapping = %{
      "a" => a,
      "b" => b,
      "c" => c,
      "d" => d,
      "e" => e,
      "f" => f,
      "g" => g
    }

    digits = %{
      convert(@coded0, mapping) => "0",
      convert(@coded1, mapping) => "1",
      convert(@coded2, mapping) => "2",
      convert(@coded3, mapping) => "3",
      convert(@coded4, mapping) => "4",
      convert(@coded5, mapping) => "5",
      convert(@coded6, mapping) => "6",
      convert(@coded7, mapping) => "7",
      convert(@coded8, mapping) => "8",
      convert(@coded9, mapping) => "9"
    }

    {output, _} =
      outputs
      |> String.split(" ", trim: true)
      |> Enum.map(fn d ->
        key = d |> String.split("", trim: true) |> Enum.sort() |> Enum.join("")
        digits[key]
      end)
      |> Enum.join("")
      |> Integer.parse()

    output
  end

  def convert(original, mapping) do
    original
    |> String.split("", trim: true)
    |> Enum.map(fn bit -> mapping[bit] end)
    |> Enum.sort()
    |> Enum.join("")
  end

  def find_f(digits, _a, _b, c, _d, _e, _g) do
    one = Enum.find(digits, &is_1?/1)

    (letters(one) -- [c])
    |> List.first()
  end

  def find_c(digits, a, _b, d, e, g) do
    mask = [a, d, e, g]

    two =
      digits
      |> Enum.filter(fn d -> length(letters(d)) == 5 end)
      |> Enum.find(fn d -> length(letters(d) -- mask) == 1 end)
      |> letters()

    (two -- mask)
    |> List.first()
  end

  def find_b(digits, a, d, e, g) do
    one = Enum.find(digits, &is_1?/1)
    eight = Enum.find(digits, &is_8?/1)
    mask = letters(one) ++ [a, d, e, g]

    (letters(eight) -- mask)
    |> List.first()
  end

  def find_d(digits, a, _e, g) do
    one = Enum.find(digits, &is_1?/1)
    mask = letters(one) ++ [a, g]

    three =
      digits
      |> Enum.filter(fn d -> length(letters(d)) == 5 end)
      |> Enum.find(fn d -> length(letters(d) -- mask) == 1 end)
      |> letters()

    (three -- mask)
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

    nine =
      digits
      |> Enum.filter(fn d -> length(letters(d)) == 6 end)
      |> Enum.find(fn d -> length(letters(d) -- mask) == 1 end)
      |> letters()

    (nine -- mask)
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
