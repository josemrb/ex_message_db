defmodule ExMessageDB do
  @moduledoc """
  An Elixir client for Message DB.
  """

  use ExMessageDB.MessageStore, repo: ExMessageDB.Repo
end
