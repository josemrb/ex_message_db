defmodule ExMessageDB.Message do
  @moduledoc """
  An Ecto type for Message data type.
  """

  use Ecto.Type

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

  defstruct [:id, :stream_name, :type, :position, :global_position, :data, :metadata, :time]

  @doc """
  Casts to Message.
  """
  def cast(data) when is_map(data) or is_list(data) do
    struct(%__MODULE__{}, data)
  end

  def cast(_), do: :error

  @doc """
  Converts a Message into a tuple.
  """
  def dump(%__MODULE__{} = message) do
    message
    |> Map.from_struct()
    |> Map.values()
    |> List.to_tuple()
  end

  def dump(_), do: :error

  @doc """
  Converts a tuple into a Message.
  """
  def load({id, stream_name, type, position, global_position, json_data, json_metadata, time}) do
    data = Jason.decode!(json_data)

    metadata =
      if is_nil(json_metadata) do
        nil
      else
        Jason.decode!(json_metadata)
      end

    module = String.to_existing_atom(type)
    module_data = Ecto.embedded_load(module, data, :json)

    {:ok,
     %__MODULE__{
       id: id,
       stream_name: stream_name,
       type: module,
       position: position,
       global_position: global_position,
       data: module_data,
       metadata: metadata,
       time: time
     }}
  end

  def load(_), do: :error

  @doc """
  Returns the underlying schema type.
  """
  def type, do: :message
end
