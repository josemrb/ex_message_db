defmodule ExMessageDB.Application do
  @moduledoc false
  use Application

  def start(_, _) do
    children = [
      {ExMessageDB.Repo, []}
    ]

    opts = [strategy: :one_for_one, name: ExMessageDB.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
