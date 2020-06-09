defmodule ExMessageDB.MessageStoreFactory do
  @moduledoc """
  MessageStore factory.
  """

  use ExMachina

  alias Ecto.UUID

  alias ExMessageDB.{DataGenerator, TestEvent}

  def message_factory(attrs) when is_map(attrs) do
    %{
      id: UUID.generate(),
      stream_name: sequence(:stream_name, &"stream-#{&1}"),
      data: build(:event)
    }
    |> merge_attributes(attrs)
  end

  def event_factory(attrs) when is_map(attrs) do
    %{
      name: sequence("event_name"),
      amount: DataGenerator.random_amount(),
      enabled: DataGenerator.random_boolean(),
      since: DateTime.utc_now()
    }
    |> TestEvent.create!()
  end
end
