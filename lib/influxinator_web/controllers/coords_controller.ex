defmodule InfluxinatorWeb.CoordsController do
  use Phoenix.Controller
  alias Influxinator.TransportationPipeline.Producer

  def add(conn, coord) do
    Producer.add(coord)
    conn
    |> put_status(201)
    |> json(%{})
  end
end
