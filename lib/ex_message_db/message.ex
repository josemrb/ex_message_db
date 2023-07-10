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

  def cast(_data), do: :error

  @doc """
  Converts a Message into a Tuple.

  TODO is the order guaranteed...?
  """
  @spec dump(data :: t()) :: {:ok, tuple()} | :error
  def dump(%__MODULE__{} = data) do
    result =
      data
      |> Map.from_struct()
      |> Map.values()
      |> List.to_tuple()

    {:ok, result}
  end

  def dump(_message), do: :error

  @doc """
  Converts a Tuple into a Message.
  """
  @spec load(data :: tuple()) :: {:ok, t()} | :error
  def load(
        {id, stream_name, type_string, position, global_position, json_data, json_metadata, time}
      ) do
    {type, data} = load_data(type_string, json_data)

    metadata = load_metadata(json_metadata)

    {:ok,
     %__MODULE__{
       id: id,
       stream_name: stream_name,
       type: type,
       position: position,
       global_position: global_position,
       data: data,
       metadata: metadata,
       time: time
     }}
  end

  def load(_data), do: :error

  @doc """
  Returns the underlying schema type.
  """
  def type, do: :message

  defp load_data(type_string, json_data) do
    # credo:disable-for-next-line Credo.Check.Warning.UnsafeToAtom
    possible_module = String.to_atom(type_string)
    map_data = Jason.decode!(json_data)

    if Code.ensure_loaded?(possible_module) do
      {possible_module, Ecto.embedded_load(possible_module, map_data, :json)}
    else
      {type_string, map_data}
    end
  end

  defp load_metadata(json_metadata) do
    if is_nil(json_metadata) do
      nil
    else
      Jason.decode!(json_metadata)
    end
  end
end
