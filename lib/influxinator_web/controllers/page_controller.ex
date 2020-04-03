defmodule InfluxinatorWeb.PageController do
  use InfluxinatorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
