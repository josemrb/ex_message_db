defmodule ExMessageDB.MessageStore do
  @moduledoc """
  Message Store.
  """
  @moduledoc since: "0.1.0"

  alias Ecto.Schema

  alias ExMessageDB.Message

  @doc """
  Retrieve messages from a category of streams, optionally specifying the starting position,
  the number of messages to retrieve.
  """
  @doc since: "0.1.0"
  @callback get_category_messages(
              category_name :: String.t(),
              position :: non_neg_integer() | nil,
              batch_size :: integer() | nil
            ) :: {:ok, [] | [%{message: Message.t()}]} | {:error, message :: String.t()}

  @doc """
  Retrieve messages from a single stream, optionally specifying the starting position, the number
  of messages to retrieve.
  """
  @doc since: "0.1.0"
  @callback get_stream_messages(
              stream_name :: String.t(),
              position :: non_neg_integer() | nil,
              batch_size :: integer() | nil
            ) ::
              {:ok, [] | [%{message: Message.t()}]} | {:error, message :: String.t()}

  @doc """
  Returns the version number of the message store database.
  """
  @doc since: "0.1.0"
  @callback message_store_version() ::
              {:ok, string_version :: String.t()} | {:error, message :: String.t()}

  @doc """
  Write a JSON-formatted message to a named stream, optionally specifying JSON-formatted metadata
  and an expected version number.

  Returns the position of the message written.
  """
  @doc since: "0.1.0"
  @callback write_message(
              id :: String.t(),
              stream_name :: String.t(),
              embedded_schema :: Schema.embedded_schema(),
              metadata :: map() | nil,
              expected_version :: integer() | nil
            ) ::
              {:ok, position :: non_neg_integer()} | {:error, message :: String.t()}

  @doc false
  defmacro __using__(options) do
    repo = Keyword.get(options, :repo)
    if is_nil(repo), do: raise(ArgumentError, message: "missing required :repo key.")

    quote bind_quoted: [repo: repo], location: :keep do
      @behaviour ExMessageDB.MessageStore
      @repo repo

      alias ExMessageDB.Adapter

      def get_category_messages(category_name, position, batch_size) do
        Adapter.get_category_messages(
          category_name,
          position,
          batch_size,
          nil,
          nil,
          nil,
          nil,
          repo: @repo
        )
      end

      def get_stream_messages(stream_name, position, batch_size) do
        Adapter.get_stream_messages(
          stream_name,
          position,
          batch_size,
          nil,
          repo: @repo
        )
      end

      def message_store_version do
        Adapter.message_store_version(repo: @repo)
      end

      def write_message(
            id,
            stream_name,
            embedded_schema,
            metadata \\ nil,
            expected_version \\ nil
          ) do
        Adapter.write_message(
          id,
          stream_name,
          embedded_schema,
          metadata,
          expected_version,
          repo: @repo
        )
      end
    end
  end
end
