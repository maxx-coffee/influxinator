defmodule Influxinator.Db.Client do
  @moduldoc """
  Module used to interfaace with influx DB.
  """
  alias Influxinator.InfluxConnection

  def add_fields(series, fields) do
    fields =
      series.fields
      |> Map.merge(fields)

    %{series | fields: fields}
  end

  def add_tags(series, tags) do
    tags =
      series.tags
      |> Map.merge(tags)

    %{series | tags: tags}
  end

  def write_series(series) do
    connection().write(series)
  end

  def build_location_query() do
    %{
      query: "SELECT * FROM location",
      where: %{}
    }
  end

  def where(%{where: where} = query_context, field, value) do
    %{query_context | where: where |> Map.put(field, value)}
  end

  def between(%{where: where} = query_context, from, to) do
    where = where |> Map.merge(%{from: from, to: to})
    %{query_context | where: where}
  end

  def query(%{where: where, query: query}) when map_size(where) == 0 do
    query
    |> connection().query()
  end

  def query(%{where: where_clauses} = query_context) do
    query_context
    |> create_where_clause()
    |> connection().query(params: where_clauses)
  end

  defp create_where_clause(%{query: query, where: where_clauses}) do
    where_clauses
    |> Enum.with_index(1)
    |> Enum.reduce(query <> " WHERE ", fn {{field, _}, index}, acc ->
      clause = acc <> create_clause(field)

      if index != map_size(where_clauses) do
        clause <> " and "
      else
        clause
      end
    end)
  end

  defp create_clause(field) when field in [:from, :to] do
    case field do
      :from -> "time >= $#{field}"
      :to -> "time <= $#{field}"
    end
  end

  defp create_clause(field) do
    "#{field} = $#{field}"
  end

  defp connection() do
    Application.get_env(:influxinator, :influx_connection, InfluxConnection)
  end
end

# query = Influxinator.Db.Client.build_location_query() 
# query = query |> Influxinator.Db.Client.where("identifier", "10") 
# query = query |> Influxinator.Db.Client.where("speed", 100) 
# query |> Influxinator.Db.Client.query()
