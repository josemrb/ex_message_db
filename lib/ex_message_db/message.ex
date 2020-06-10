defmodule ExMessageDB.Message do
  @moduledoc """
  An Ecto type for Message data type.
  """

  use Ecto.Type

  defstruct [:id, :stream_name, :type, :position, :global_position, :data, :metadata, :time]

  @typedoc """
  A representation of Message data type.
  """
  @type t :: %__MODULE__{
          id: String.t(),
          stream_name: String.t(),
          type: module(),
          position: non_neg_integer(),
          global_position: non_neg_integer(),
          data: Ecto.Schema.embedded_schema(),
          metadata: map() | nil,
          time: DateTime.t()
        }

  @doc """
  Casts to Message.
  """
  @spec cast(data :: map() | list()) :: {:ok, t()} | :error
  def cast(data) when is_map(data) or is_list(data) do
    {:ok, struct!(%__MODULE__{}, data)}
  end

  def cast(_), do: :error

  @doc """
  Converts a Message into a Tuple.
  """
  @spec dump(message :: t()) :: {:ok, tuple()} | :error
  def dump(%__MODULE__{} = message) do
    result =
      message
      |> Map.from_struct()
      |> Map.values()
      |> List.to_tuple()

    {:ok, result}
  end

  def dump(_), do: :error

  @doc """
  Converts a Tuple into a Message.
  """
  @spec load(data :: tuple()) :: {:ok, t()} | :error
  def load(
        {id, stream_name, type_string, position, global_position, json_data, json_metadata, time}
      ) do
    type = String.to_existing_atom(type_string)

    map_data = Jason.decode!(json_data)
    data = Ecto.embedded_load(type, map_data, :json)

    metadata =
      if is_nil(json_metadata) do
        nil
      else
        Jason.decode!(json_metadata)
      end

    {:ok,
     struct!(%__MODULE__{}, %{
       id: id,
       stream_name: stream_name,
       type: type,
       position: position,
       global_position: global_position,
       data: data,
       metadata: metadata,
       time: time
     })}
  end

  def load(_), do: :error

  @doc """
  Returns the underlying schema type.
  """
  def type, do: :message
end
