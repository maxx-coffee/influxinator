defmodule Influxinator.Db.ClientTest do
  use ExUnit.Case
  import Mox

  alias Influxinator.Db.Client
  alias Influxinator.Db.LocationMeasurement

  describe "Building client queries" do
    setup :verify_on_exit!

    test "testing building query with where clauses" do
      Influxinator.InfluxConnectionMock
      |> expect(:query, fn query, _ -> query end)

      assert Client.build_location_query()
             |> Client.where("test", "test")
             |> Client.where("foo", "bar")
             |> Client.query() == "SELECT * FROM location WHERE  foo = $foo and  test = $test"
    end

    test "testing building query with between clauses" do
      Influxinator.InfluxConnectionMock
      |> expect(:query, fn query, _ -> query end)

      assert Client.build_location_query()
             |> Client.between("2016-06-15T00:00:00Z", "2017-06-15T00:00:00Z")
             |> Client.query() == "SELECT * FROM location WHERE time >= $from and time <= $to"
    end

    test "testing building query with between and where clauses" do
      Influxinator.InfluxConnectionMock
      |> expect(:query, fn query, _ -> query end)

      assert Client.build_location_query()
             |> Client.where("foo", "bar")
             |> Client.between("2016-06-15T00:00:00Z", "2017-06-15T00:00:00Z")
             |> Client.query() ==
               "SELECT * FROM location WHERE time >= $from and time <= $to and  foo = $foo"
    end

    test "Writing series to influx" do
      Influxinator.InfluxConnectionMock
      |> expect(:write, fn series -> {:ok, series} end)

      assert %LocationMeasurement{}
             |> Client.add_fields(%{speed: 100})
             |> Client.add_fields(%{lat: "lat", long: "long"})
             |> Client.add_tags(%{identifier: "22"})
             |> Client.add_tags(%{job_id: "22"})
             |> Client.write_series() ==
               {:ok,
                %Influxinator.Db.LocationMeasurement{
                  timestamp: nil,
                  fields: %Influxinator.Db.LocationMeasurement.Fields{
                    speed: 100,
                    lat: "lat",
                    long: "long"
                  },
                  tags: %Influxinator.Db.LocationMeasurement.Tags{identifier: "22", job_id: "22"}
                }}
    end
  end
end
