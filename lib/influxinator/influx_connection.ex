defmodule Influxinator.InfluxConnection do
  use Instream.Connection, otp_app: :influxinator
  @callback query(query :: String.t()) :: any
  @callback query(query :: String.t(), opts :: Keyword.t()) :: any
  @callback write(payload :: map | [map]) :: any
  @callback write(payload :: map | [map], opts :: Keyword.t()) :: any
end
