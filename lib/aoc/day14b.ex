defmodule AOC.Day14b do
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
      |> step(rules, 40)
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

  def step(input, rules, n) do
    1..n
    |> Enum.reduce(input, fn _, acc -> grow(acc, rules) end)
  end

  # def step(input, _rules, 0), do: input

  # def step(input, rules, n) do
  #   input
  #   |> grow(rules)
  #   |> step(rules, n - 1)
  # end

  def grow([], _rules), do: []
  def grow([e], _rules), do: [e]

  def grow([e1, e2 | input], rules) do
    [e1, rules[[e1, e2]] | grow([e2 | input], rules)]
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
