defmodule Influxinator.Repo do
  use Ecto.Repo,
    otp_app: :influxinator,
    adapter: Ecto.Adapters.Postgres
end
