defmodule ExMessageDB.Adapter do
  @moduledoc """
  Adapter
  """

  alias Ecto.Repo
  alias ExMessageDB.Functions
  alias ExMessageDB.Message

  @type maybe(t) :: nil | t

  @spec get_category_messages(
          category_name :: String.t(),
          position :: non_neg_integer() | nil,
          batch_size :: non_neg_integer() | -1 | nil,
          Repo.t()
        ) :: [] | [%{message: Message.t()}] | {:error, message :: String.t()}
  def get_category_messages(
        category_name,
        position,
        batch_size,
        repo
      ) do
    sql = "SELECT get_category_messages($1, $2, $3, $4, $5, $6, $7)"
    params = [category_name, position, batch_size, nil, nil, nil, nil]
    repo.query(sql, params) |> map_results([])
  end

  # TODO I don't want my Message contained in a stupid map
  # TODO This function can also apparently return an error tuple
  @spec get_last_stream_message(stream_name :: String.t(), Repo.t()) ::
          maybe(%{message: Message.t()})
  def get_last_stream_message(stream_name, repo) do
    sql = "SELECT get_last_stream_message($1)"
    params = [stream_name]

    repo.query(sql, params)
    |> map_first_result([])
  end

  @spec get_stream_messages(
          stream_name :: String.t(),
          position :: non_neg_integer() | nil,
          batch_size :: non_neg_integer() | -1 | nil,
          opts :: [{:repo, Repo.t()}]
        ) :: [] | [%{message: Message.t()}] | {:error, message :: String.t()}
  def get_stream_messages(stream_name, position, batch_size, repo) do
    sql = "SELECT get_stream_messages($1, $2, $3, $4)"
    params = [stream_name, position, batch_size, nil]
    repo.query(sql, params) |> map_results(opts)
  end

  @spec message_store_version(Repo.t()) :: String.t()
  def message_store_version(repo) do
    sql = "SELECT message_store_version()"
    repo.query(sql, []) |> map_first_result(opts)
  end

  @spec write_message(
          id :: String.t(),
          stream_name :: String.t(),
          type :: String.t(),
          data :: map(),
          metadata :: map() | nil,
          expected_version :: non_neg_integer() | -1 | nil,
          opts :: [{:repo, Repo.t()}]
        ) :: {:ok, position :: non_neg_integer()} | {:error, message :: String.t()}
  def write_message(id, stream_name, type, data, metadata, expected_version, opts) do
    repo = Keyword.fetch!(opts, :repo)

    {sql, params} =
      Functions.write_message(id, stream_name, type, data, metadata, expected_version)

    repo.query(sql, params)
    |> map_tuple_result(opts)
  end

  defp map_first_result({:ok, %Postgrex.Result{rows: rows}}, opts) do
    case rows do
      [] -> nil
      [result | _] when is_binary(result) or is_integer(result) -> result
      [result | _] -> map_row(result, opts)
    end
  end

  defp map_first_result({:error, %Postgrex.Error{postgres: %{message: message}}}, opts)
       when is_binary(message) and is_list(opts) do
    {:error, message}
  end

  defp map_tuple_result({:ok, %Postgrex.Result{num_rows: 1, rows: [[result]]}}, opts)
       when (is_binary(result) or is_integer(result)) and is_list(opts) do
    {:ok, result}
  end

  defp map_tuple_result({:error, %Postgrex.Error{postgres: %{message: message}}}, opts)
       when is_binary(message) and is_list(opts) do
    {:error, message}
  end

  defp map_results({:ok, %Postgrex.Result{num_rows: 0, rows: []}}, opts) when is_list(opts) do
    []
  end

  defp map_results({:ok, %Postgrex.Result{num_rows: num_rows, rows: rows}}, opts)
       when num_rows > 0 and is_list(rows) and is_list(opts) do
    Enum.map(rows, &map_row(&1, opts))
  end

  defp map_results({:error, %Postgrex.Error{postgres: %{message: message}}}, opts)
       when is_binary(message) and is_list(opts) do
    {:error, message}
  end

  defp map_row(row, opts) when is_list(row) and is_list(opts) do
    repo = Keyword.fetch!(opts, :repo)
    types = %{message: Message}
    repo.load(types, {[:message], row})
  end
end
