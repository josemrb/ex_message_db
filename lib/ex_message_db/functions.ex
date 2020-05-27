defmodule ExMessageDb.Functions do
  @moduledoc """
  Defines SQL functions
  """

  def message_store_version do
    function_signature = "message_store_version()"

    [
      "SELECT #{function_signature}",
      []
    ]
  end
end
