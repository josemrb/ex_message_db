defmodule ExMessageDB.MessageStoreFactory do
  @moduledoc """
  MessageStore factory.
  """

  use ExMachina

  alias Ecto.UUID

  alias ExMessageDB.DataGenerator
  alias ExMessageDB.TestEvent

  def message_factory(attrs) when is_map(attrs) do
    category_name = Map.get(attrs, :category_name, "stream")

    %{
      id: UUID.generate(),
      stream_name: sequence(:stream_name, &"#{category_name}-#{&1}"),
      embedded_data: build(:event)
    }
    |> merge_attributes(attrs)
  end

  def message_data_map_factory(attrs) when is_map(attrs) do
    category_name = Map.get(attrs, :category_name, "stream")

    %{
      id: UUID.generate(),
      stream_name: sequence(:stream_name, &"#{category_name}-#{&1}"),
      type: sequence("StringType"),
      data: %{
        name: sequence("map_"),
        amount: DataGenerator.random_amount()
      }
    }
    |> merge_attributes(attrs)
  end

  def event_factory(attrs) when is_map(attrs) do
    %{
      name: sequence("event_"),
      amount: DataGenerator.random_amount(),
      enabled: DataGenerator.random_boolean(),
      since: DateTime.utc_now()
    }
    |> TestEvent.create!()
  end
end
