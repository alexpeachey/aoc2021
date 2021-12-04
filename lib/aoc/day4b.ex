defmodule AOC.Day4b do
  import AOC

  def solution(path) do
    input =
      path
      |> read_lines()

    [numbers | boards] = input

    numbers =
      numbers
      |> String.split(",")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn {n, _} -> n end)

    boards = format_boards(boards)
    {board, n} = find_last_winner(numbers, boards)
    board_score = score_board(board)
    board_score * n
  end

  def score_board(board) do
    board
    |> Enum.map(&score_row/1)
    |> Enum.sum()
  end

  def score_row(row) do
    row
    |> Enum.map(fn
      {_, 1} -> 0
      {n, 0} -> n
    end)
    |> Enum.sum()
  end

  def find_last_winner([n | numbers], [board]) do
    board = mark_board(board, n)

    if winning_board?(board) do
      {board, n}
    else
      find_last_winner(numbers, [board])
    end
  end

  def find_last_winner([n | numbers], boards) do
    boards =
      boards
      |> Enum.map(&mark_board(&1, n))

    case Enum.filter(boards, &winning_board?/1) do
      [] -> find_last_winner(numbers, boards)
      winners -> find_last_winner(numbers, boards -- winners)
    end
  end

  def winning_board?(board) do
    board
    |> Enum.find(&winning_row?/1)
    |> case do
      nil ->
        board
        |> transpose()
        |> Enum.find(&winning_row?/1)
        |> case do
          nil -> false
          _ -> true
        end

      _ ->
        true
    end
  end

  def winning_row?(row) do
    row
    |> Enum.all?(fn
      {_, 1} -> true
      {_, 0} -> false
    end)
  end

  def mark_board(board, n) do
    board
    |> Enum.map(&mark_row(&1, n))
  end

  def mark_row(row, n) do
    row
    |> Enum.map(&mark_cell(&1, n))
  end

  def mark_cell({n, _}, n), do: {n, 1}
  def mark_cell(cell, _), do: cell

  def format_boards(boards) do
    boards
    |> Enum.map(&String.split/1)
    |> Enum.map(&init_board/1)
    |> Enum.chunk_every(5)
  end

  def init_board(board) do
    board
    |> Enum.map(&init_cell/1)
  end

  def init_cell(n) do
    {n, _} = Integer.parse(n)
    {n, 0}
  end

  def transpose(list) do
    list
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
