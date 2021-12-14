defmodule AOC.Day14a do
  import AOC

  def solution(path) do
    [input | rules] =
      path
      |> read_lines()

    rules =
      rules
      |> parse_rules()

    elements =
      input
      |> String.split("", trim: true)
      |> grow(rules, 10)
      |> Enum.frequencies()

    min_count =
      elements
      |> Map.values()
      |> Enum.min()

    max_count =
      elements
      |> Map.values()
      |> Enum.max()

    max_count - min_count
  end

  def grow(input, _rules, 0), do: input

  def grow(input, rules, n) do
    input
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [c1, c2] = key ->
      [c1, rules[key], c2]
    end)
    |> Enum.reduce([], fn
      [c1, c2, c3], [] -> [c1, c2, c3]
      [_c1, c2, c3], acc -> acc ++ [c2, c3]
    end)
    |> grow(rules, n - 1)
  end

  def parse_rules(rules) do
    rules
    |> Enum.map(&String.split(&1, " -> ", trim: true))
    |> Enum.map(&parse_rule/1)
    |> Enum.into(%{})
  end

  def parse_rule([input, output]) do
    key =
      input
      |> String.split("", trim: true)

    {key, output}
  end
end
