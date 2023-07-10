defmodule ExMessageDB.Functions do
  @moduledoc """
  Functions
  """

  @spec message_store_version :: {sql :: String.t(), params :: []}
  def message_store_version do
    function_call = "message_store_version()"

    {
      "SELECT #{function_call}",
      []
    }
  end

  @spec write_message(
          id :: String.t(),
          stream_name :: String.t(),
          type :: String.t(),
          data :: map(),
          metadata :: map() | nil,
          expected_version :: non_neg_integer() | -1 | nil
        ) :: {sql :: String.t(), params :: [term()]}
  def write_message(id, stream_name, type, data, metadata, expected_version) do
    function_call = "write_message($1, $2, $3, $4, $5, $6)"

    {
      "SELECT #{function_call}",
      [id, stream_name, type, data, metadata, expected_version]
    }
  end
end
