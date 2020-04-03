defmodule Influxinator.Db.LocationMeasurement do
  use Instream.Series

  series do
    database("influxinator")
    measurement("location")

    tag(:identifier)
    tag(:job_id)

    field :speed
    field :lat
    field :long
  end
end

# data = %Influxinator.Db.LocationMeasurement{}
# data = %{data | tags: %{data.tags | identifier: 10, job_id: 22}}
# data = %{data | fields: %{data.fields | lat: "test", long: "test", speed: 100}}
# Influxinator.InfluxConnection.write(data)
