defmodule ExMessageDb do
  @moduledoc """
  Documentation for `ExMessageDb`.
  """
  alias ExMessageDb.{Repo, Service}

  @doc """
  Returns the version number of the message store database.
  """
  def message_store_version do
    Service.message_store_version(Repo)
  end
end
