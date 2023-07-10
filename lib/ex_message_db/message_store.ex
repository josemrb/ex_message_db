defmodule ExMessageDB.MessageStore do
  @moduledoc """
  Defines a message store.

  When used, the message store expects the `:repo` option.
  For example:

      defmodule MyApp.MessageStore do
        use ExMessageDB.MessageStore, repo: MyApp.Repo
      end
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
              batch_size :: non_neg_integer() | -1 | nil
            ) :: [] | [%{message: Message.t()}] | {:error, message :: String.t()}

  @doc """
  Returns the row from the messages table that corresponds to the highest position number
  in the stream.
  """
  @doc since: "0.1.0"
  @callback get_last_stream_message(stream_name :: String.t()) ::
              nil | %{message: Message.t()}

  @doc """
  Retrieve messages from a single stream, optionally specifying the starting position, the number
  of messages to retrieve.
  """
  @doc since: "0.1.0"
  @callback get_stream_messages(
              stream_name :: String.t(),
              position :: non_neg_integer() | nil,
              batch_size :: non_neg_integer() | -1 | nil
            ) ::
              [] | [%{message: Message.t()}] | {:error, message :: String.t()}

  @doc """
  Returns the version number of the message store database.
  """
  @doc since: "0.1.0"
  @callback message_store_version() ::
              string_version :: String.t()

  @doc """
  Write a JSON-formatted message to a named stream, optionally specifying JSON-formatted metadata
  and an expected version number.

  Returns the position of the message written.
  """
  @doc since: "0.1.0"
  @callback write_message(%{
              id: id :: String.t(),
              stream_name: stream_name :: String.t(),
              embedded_data: Schema.embedded_schema()
            }) ::
              {:ok, position :: non_neg_integer()} | {:error, message :: String.t()}
  @callback write_message(%{
              id: id :: String.t(),
              stream_name: stream_name :: String.t(),
              type: type :: String.t(),
              data: map()
            }) ::
              {:ok, position :: non_neg_integer()} | {:error, message :: String.t()}

  @doc """
  See `c:write_message/1` for more information.
  """
  @doc since: "0.1.0"
  @callback write_message(
              id :: String.t(),
              stream_name :: String.t(),
              embedded_data :: Schema.embedded_schema(),
              metadata :: map() | nil,
              expected_version :: non_neg_integer() | -1 | nil
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

      def get_category_messages(category_name, position \\ nil, batch_size \\ nil)
          when is_binary(category_name) do
        Adapter.get_category_messages(category_name, position, batch_size, @repo)
      end

      def get_last_stream_message(stream_name) when is_binary(stream_name) do
        Adapter.get_last_stream_message(stream_name, @repo)
      end

      def get_stream_messages(stream_name, position \\ nil, batch_size \\ nil)
          when is_binary(stream_name) do
        Adapter.get_stream_messages(stream_name, position, batch_size, @repo)
      end

      def message_store_version do
        Adapter.message_store_version(@repo)
      end

      def write_message(
            %{
              id: id,
              stream_name: stream_name,
              embedded_data: embedded_data
            } = params
          )
          when is_binary(id) and is_binary(stream_name) and is_struct(embedded_data) do
        metadata = Map.get(params, :metadata)
        expected_version = Map.get(params, :expected_version)

        write_message(
          id,
          stream_name,
          embedded_data,
          metadata,
          expected_version
        )
      end

      def write_message(
            %{
              id: id,
              stream_name: stream_name,
              type: type,
              data: data
            } = params
          )
          when is_binary(id) and is_binary(stream_name) and is_binary(type) and is_map(data) do
        metadata = Map.get(params, :metadata)
        expected_version = Map.get(params, :expected_version)

        Adapter.write_message(
          id,
          stream_name,
          type,
          data,
          metadata,
          expected_version,
          @repo
        )
      end

      def write_message(
            id,
            stream_name,
            embedded_data,
            metadata \\ nil,
            expected_version \\ nil
          )
          when is_binary(id) and is_binary(stream_name) and is_struct(embedded_data) do
        type = Atom.to_string(embedded_data.__struct__)
        data = Map.from_struct(embedded_data)

        Adapter.write_message(
          id,
          stream_name,
          type,
          data,
          metadata,
          expected_version,
          @repo
        )
      end
    end
  end
end
