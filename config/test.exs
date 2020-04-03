use Mix.Config

# Configure your database
config :influxinator, Influxinator.Repo,
  username: "postgres",
  password: "postgres",
  database: "influxinator_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :influxinator, InfluxinatorWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :influxinator, :influx_connection, Influxinator.InfluxConnectionMock
config :logger, level: :warn
