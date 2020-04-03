defmodule InfluxinatorWeb.Router do
  use InfluxinatorWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    
  end

  scope "/", InfluxinatorWeb do
    post "/coords", CoordsController, :add
  end

  # Other scopes may use custom stacks.
  # scope "/api", InfluxinatorWeb do
  #   pipe_through :api
  # end
end
