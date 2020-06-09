defmodule ExMessageDB.RepoCase do
  use ExUnit.CaseTemplate
  @moduledoc false
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias ExMessageDB.Repo
      alias ExMessageDB.TestEvent

      import Ecto
      import Ecto.Query
      import ExMessageDB.RepoCase
    end
  end

  setup tags do
    :ok = Sandbox.checkout(ExMessageDB.Repo)

    unless tags[:async] do
      Sandbox.mode(ExMessageDB.Repo, {:shared, self()})
    end

    :ok
  end
end
