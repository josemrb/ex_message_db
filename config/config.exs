import Config

if Mix.env() == :test do
  config :ex_message_db, ExMessageDB.Repo,
    database: "message_store_test",
    username: "postgres",
    hostname: "localhost",
    pool: Ecto.Adapters.SQL.Sandbox
else
  config :ex_message_db, ExMessageDB.Repo,
    database: "message_store",
    username: "postgres",
    hostname: "localhost"
end
