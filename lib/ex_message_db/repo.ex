defmodule ExMessageDb.Repo do
  use Ecto.Repo,
    otp_app: :ex_message_db,
    adapter: Ecto.Adapters.Postgres,
    read_only: true
end
