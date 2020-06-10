defmodule ExMessageDB.RepoCase do
  use ExUnit.CaseTemplate
  @moduledoc false
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias ExMessageDB.Message
      alias ExMessageDB.Repo

      import ExMessageDB.MessageStoreFactory
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
