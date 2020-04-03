defmodule Influxinator.TransportationPipeline.Producer do
  use GenStage

  def start_link(_initial) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:producer, []}
  end

  def add(coords), do: GenServer.cast(__MODULE__, {:add, coords})

  def handle_cast({:add, coords}, state) when is_list(coords) do
    {:noreply, coords, state ++ coords}
  end

  def handle_cast({:add, coord}, state), do: {:noreply, [coord], state ++ [coord]}

  def handle_demand(demand, coords) when demand > 0 do
    process_coords = coords |> Enum.take(demand)
    coords = coords |> Enum.drop(demand)
    {:noreply, process_coords, coords}
  end
end
