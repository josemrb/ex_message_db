defmodule ExMessageDb.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      {ExMessageDb.Repo, []}
    ]

    opts = [strategy: :one_for_one, name: ExMessageDb.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
