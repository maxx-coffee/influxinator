defmodule Influxinator.TransportationPipeline.Consumer do
  alias Influxinator.Db.Client
  alias Influxinator.Db.LocationMeasurement
  use GenStage

  def start_link(_initial) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:consumer, [],
     subscribe_to: [{Influxinator.TransportationPipeline.Producer, max_demand: 10, min_demand: 5}]}
  end

  def handle_events(coords, _from, state) do
    Enum.map(coords, fn %{"identifier" => identifier} = coord ->
      job_id =
        case get_job_for_driver(identifier) do
          nil -> nil
          job -> job.id
        end

      fields = coord |> Map.take(["speed", "lat", "long"])
      randomly_check_speed(coord)

      %LocationMeasurement{}
      |> Client.add_tags(%{job_id: job_id, identifier: identifier})
      |> Client.add_fields(fields)
    end)
    |> Client.write_series()

    {:noreply, [], state}
  end

  defp get_job_for_driver(identifier) do
    nil
  end

  @doc """
  Mock function as a place holder to show we would need to randomly check
  the users speed against mapbox's speed datapoints.

  This would be stored in another influxDB database to later be matched against
  our GPS data points.

  The idea here would be to push this to another Genstage that would rate limit 
  against the mapbox API.
  """
  defp randomly_check_speed(_) do
    :ok
  end
end
