defmodule Influxinator.JobTracker do
  use GenServer
  alias Influxinator.Db.Client
  @impl true
  def init(job_id) do
    state = %{
      job_id: job_id,
      job_start_time: nil,
      location_coords: nil,
      time_to_destination: nil,
      coordinates: [],
      last_checked: nil
    }

    # send(self(), :calculate_time_to_destination)
    send(self(), :fetch_new_coordinates)
    {:ok, state}
  end

  # def handle_continue(:more_init, state) do
  #   data = get_data(state.type)
  #   updated_state = Map.put(state, :data, data)
  #   {:noreply, updated_state}
  # end
  @impl true
  def handle_info(:calculate_time_to_destination, state) do
    Process.send_after(self(), :calculate_time_to_destination, 60_000)
    {:noreply, state}
  end

  @impl true
  def handle_info(:fetch_new_coordinates, %{job_id: job_id, last_checked: last_checked} = state) do
    last_checked =
      if is_nil(last_checked) do
        DateTime.utc_now()
      else
        last_checked
      end

    checked_at = DateTime.utc_now()

    coords =
      Client.build_location_query()
      |> Client.where("job_id", job_id)
      |> Client.between(
        last_checked |> DateTime.to_iso8601(),
        checked_at |> DateTime.to_iso8601()
      )
      |> Client.query()

    Process.send_after(self(), :fetch_new_coordinates, 10_000)
    {:noreply, %{state | last_checked: checked_at}}
  end
end
