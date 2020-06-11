defmodule ExMessageDB.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :ex_message_db,
    adapter: Ecto.Adapters.Postgres,
    read_only: true

  def init(_type, config) do
    prefix = "message_store"
    after_connect_callback = {Postgrex, :query!, ["SET search_path TO #{prefix}", []]}
    config = Keyword.put(config, :after_connect, after_connect_callback)

    {:ok, config}
  end
end
