defmodule ExMessageDB.Functions do
  @moduledoc """
  Functions.
  """

  @spec get_stream_messages(
          stream_name :: String.t(),
          position :: non_neg_integer() | nil,
          batch_size :: non_neg_integer() | -1 | nil,
          condition :: Keyword.t() | nil
        ) :: {sql :: String.t(), params :: [term()]}
  def get_stream_messages(stream_name, position, batch_size, nil) do
    function_call = "get_stream_messages($1, $2, $3, $4)"

    {
      "SELECT #{function_call}",
      [stream_name, position, batch_size, nil]
    }
  end

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
