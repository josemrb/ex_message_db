defmodule ExMessageDB do
  @moduledoc """
  An Elixir Message DB Client.
  """

  use ExMessageDB.MessageStore, repo: ExMessageDB.Repo
end
