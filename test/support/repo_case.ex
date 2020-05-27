defmodule ExMessageDb.RepoCase do
  use ExUnit.CaseTemplate
  @moduledoc false
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias ExMessageDb.Repo

      import Ecto
      import Ecto.Query
      import ExMessageDb.RepoCase
    end
  end

  setup tags do
    :ok = Sandbox.checkout(ExMessageDb.Repo)

    unless tags[:async] do
      Sandbox.mode(ExMessageDb.Repo, {:shared, self()})
    end

    :ok
  end
end
