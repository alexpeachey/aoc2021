defmodule AOC.Day11a do
  import AOC

  defmodule OctoServer do
    use GenServer

    def init(grid) do
      {:ok, grid}
    end

    def handle_cast({:energize, id}, grid) do
      {:noreply, %{grid | id => energize(grid[id])}}
    end

    def handle_cast({:drain, id}, grid) do
      {:noreply, %{grid | id => drain(grid[id])}}
    end

    def handle_call({:flash, id}, _caller, grid) do
      {modified, octo} = flash(grid[id])
      {:reply, modified, %{grid | id => octo}}
    end

    def handle_call(:grid, _caller, grid) do
      {:reply, grid, grid}
    end

    def handle_call(:ids, _caller, grid) do
      {:reply, Map.keys(grid), grid}
    end

    def handle_call(:octos, _caller, grid) do
      {:reply, Map.values(grid), grid}
    end

    def handle_call(:flashes, _caller, grid) do
      flashes =
        grid
        |> Enum.map(fn {_id, %{flashes: flashes}} -> flashes end)
        |> Enum.sum()

      {:reply, flashes, grid}
    end

    def energize(%{value: energy} = octo) when energy > 9, do: octo
    def energize(%{value: energy} = octo), do: %{octo | value: energy + 1}

    def flash(%{flashed: true} = octo), do: {[], octo}
    def flash(%{value: energy} = octo) when energy <= 9, do: {[], octo}

    def flash(octo) do
      {
        octo.neighbors,
        %{octo | flashes: octo.flashes + 1, flashed: true}
      }
    end

    def drain(%{value: energy} = octo) when energy > 9, do: %{octo | value: 0, flashed: false}
    def drain(octo), do: %{octo | flashed: false}
  end

  def solution(path) do
    grid =
      path
      |> read_lines()
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(&Enum.map(&1, fn d -> to_int(d) end))
      |> create_grid()
      |> Enum.into(%{})

    {:ok, pid} = GenServer.start_link(AOC.Day11a.OctoServer, grid)
    step(pid, 100)
    GenServer.call(pid, :flashes)
  end

  def step(pid, 0), do: pid

  def step(pid, n) do
    GenServer.call(pid, :ids)
    |> Enum.map(fn id -> GenServer.cast(pid, {:energize, id}) end)

    flash(pid)

    GenServer.call(pid, :ids)
    |> Enum.map(fn id -> GenServer.cast(pid, {:drain, id}) end)

    step(pid, n - 1)
  end

  def flash(pid) do
    GenServer.call(pid, :ids)
    |> Enum.flat_map(fn id -> GenServer.call(pid, {:flash, id}) end)
    |> case do
      [] ->
        :ok

      to_energize ->
        to_energize
        |> Enum.map(fn id -> GenServer.cast(pid, {:energize, id}) end)

        flash(pid)
    end
  end

  def view(pid) do
    grid = GenServer.call(pid, :grid)

    for y <- 0..9 do
      for x <- 0..9, do: IO.write(grid[{x, y}].value)
      IO.write("\n")
    end
  end

  def create_grid(input) do
    for x <- 0..9,
        y <- 0..9,
        do:
          {{x, y},
           %{
             id: {x, y},
             value: Enum.at(Enum.at(input, y), x),
             neighbors: find_neighbors(x, y),
             flashes: 0,
             flashed: false
           }}
  end

  def find_neighbors(0, 0), do: [{0, 1}, {1, 0}, {1, 1}]
  def find_neighbors(9, 0), do: [{9, 1}, {8, 0}, {8, 1}]
  def find_neighbors(0, 9), do: [{0, 8}, {1, 9}, {1, 8}]
  def find_neighbors(9, 9), do: [{8, 9}, {9, 8}, {8, 8}]
  def find_neighbors(0, y), do: [{0, y - 1}, {0, y + 1}, {1, y}, {1, y - 1}, {1, y + 1}]
  def find_neighbors(x, 0), do: [{x - 1, 0}, {x + 1, 0}, {x, 1}, {x - 1, 1}, {x + 1, 1}]
  def find_neighbors(9, y), do: [{9, y - 1}, {9, y + 1}, {8, y}, {8, y - 1}, {8, y + 1}]
  def find_neighbors(x, 9), do: [{x - 1, 9}, {x + 1, 9}, {x, 8}, {x - 1, 8}, {x + 1, 8}]

  def find_neighbors(x, y),
    do: [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1},
      {x - 1, y - 1},
      {x - 1, y + 1},
      {x + 1, y - 1},
      {x + 1, y + 1}
    ]
end
