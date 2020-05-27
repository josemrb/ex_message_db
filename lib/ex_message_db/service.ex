defmodule ExMessageDb.Service do
  @moduledoc false
  alias ExMessageDb.Functions

  def message_store_version(repo) when is_atom(repo) do
    repo
    |> apply(:query, Functions.message_store_version())
    |> map_result()
  end

  defp map_result({:ok, %{num_rows: 1, rows: [[result]]}}) do
    {:ok, result}
  end

  defp map_result({:ok, %{num_rows: 0, rows: nil}}) do
    {:ok, nil}
  end
end
