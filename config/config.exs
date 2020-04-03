# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :influxinator,
  ecto_repos: [Influxinator.Repo]

# Configures the endpoint
config :influxinator, InfluxinatorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+F+9UAp9NqoOpmxKn7W/H2eQwwUr8qN6h5pUQ7OO1epUcxtNjK8lpzXQ6VB4LZcO",
  render_errors: [view: InfluxinatorWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Influxinator.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "SLHaWsap"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
config :influxinator, :influx_connection, Influxinator.InfluxConnection

config :influxinator, Influxinator.InfluxConnection,
  database: "influxinator",
  host: "localhost",
  http_opts: [insecure: true],
  pool: [max_overflow: 10, size: 50],
  port: 8086,
  scheme: "http",
  writer: Instream.Writer.Line

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
