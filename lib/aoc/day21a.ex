defmodule AOC.Day21a do
  import AOC

  def solution(path) do
    [p1, p2] =
      path
      |> read_lines()
      |> Enum.map(&parse_start/1)

    [{_p1, s1, n1}, {_p2, s2, n2}] = play({p1, 0, 0}, {p2, 0, 0}, 0)

    if s1 >= 1000 do
      s2 * (n1 + n2)
    else
      s1 * (n1 + n2)
    end
  end

  def play({p1, s1, n1}, {p2, s2, n2}, die) do
    {die, p1roll} = roll(die, 3)
    {die, p2roll} = roll(die, 3)
    np1 = move(p1, p1roll)
    np2 = move(p2, p2roll)

    cond do
      s1 + np1 >= 1000 ->
        [{np1, s1 + np1, n1 + 3}, {p2, s2, n2}]

      s1 + np2 >= 1000 ->
        [{np1, s1 + np1, n1 + 3}, {np2, s2 + np2, n2 + 3}]

      true ->
        play({np1, s1 + np1, n1 + 3}, {np2, s2 + np2, n2 + 3}, die)
    end
  end

  def move(player, roll), do: wrap(player + roll)
  def wrap(player) when player <= 10, do: player
  def wrap(player), do: wrap(player - 10)

  def roll(100), do: 1
  def roll(die), do: die + 1
  def roll(die, n), do: roll(die, 0, n)
  def roll(die, total, 0), do: {die, total}

  def roll(die, total, n) do
    die = roll(die)
    total = total + die
    roll(die, total, n - 1)
  end

  def parse_start(<<"Player ", _::binary-size(1), " starting position: ", n::binary>>) do
    {p, _} = Integer.parse(n)
    p
  end
end
