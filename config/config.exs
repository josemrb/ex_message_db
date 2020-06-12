import Config

if Mix.env() == :test do
  config :ex_message_db, ExMessageDB.Repo,
    database: "ex_message_db_test",
    username: "postgres",
    hostname: "0.0.0.0",
    pool: Ecto.Adapters.SQL.Sandbox
else
  config :ex_message_db, ExMessageDB.Repo,
    database: "ex_message_db",
    username: "postgres",
    hostname: "0.0.0.0"
end
