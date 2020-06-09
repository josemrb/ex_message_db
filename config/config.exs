import Config

config :ex_message_db,
  ecto_repos: [ExMessageDB.Repo]

if Mix.env() == :test do
  config :ex_message_db, ExMessageDB.Repo,
    database: "message_store_test",
    username: "postgres",
    hostname: "localhost",
    pool: Ecto.Adapters.SQL.Sandbox,
    after_connect: {Postgrex, :query!, ["SET search_path TO message_store", []]}
else
  config :ex_message_db, ExMessageDB.Repo,
    database: "message_store",
    username: "postgres",
    hostname: "localhost",
    after_connect: {Postgrex, :query!, ["SET search_path TO message_store", []]}
end
