ExUnit.start()
Mox.defmock(Influxinator.InfluxConnectionMock, for: Influxinator.InfluxConnection)
Ecto.Adapters.SQL.Sandbox.mode(Influxinator.Repo, :manual)
