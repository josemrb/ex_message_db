defmodule ExMessageDB.Console do
  @moduledoc """
  Console helper.
  """

  defmacro alias_internals do
    quote do
      alias ExMessageDB.Adapter
      alias ExMessageDB.Message
      alias ExMessageDB.MessageStore
      alias ExMessageDB.Repo
      nil
    end
  end
end

IO.puts("Loading ExMessageDB env started")
alias Ecto.UUID
alias ExMessageDB.Console
IO.puts("Loading ExMessageDB env finished")
