defmodule ExMessageDBTest do
  @moduledoc """
  Message DB client tests.
  """

  use ExMessageDB.RepoCase

  alias Ecto.UUID

  describe "message_store_version/0" do
    test "returns current version sucessfully" do
      assert {:ok, "1.2.3"} = ExMessageDB.message_store_version()
    end
  end

  describe "write_message/3" do
    test "returns sucessfully" do
      id = UUID.generate()
      stream_name = "Account-1"
      event = TestEvent.create!(%{name: "Event 1", amount: 100})

      assert {:ok, pos} = ExMessageDB.write_message(id, stream_name, event)
      assert pos = 0
    end

    test "returns optimistic lock error" do
      id = UUID.generate()
      stream_name = "Account-1"
      event = TestEvent.create!(%{name: "Event 1", amount: 100})
      wrong_position = 1

      assert {:error, message} =
               ExMessageDB.write_message(id, stream_name, event, nil, wrong_position)

      error_message = "Wrong expected version: #{wrong_position}"
      assert String.starts_with?(message, error_message)
    end
  end

  describe "write_message/4" do
    test "returns sucessfully" do
      id = UUID.generate()
      stream_name = "Account-1"
      event = TestEvent.create!(%{name: "Event 2", amount: 200})
      metadata = %{headers: %{"Accept-Encoding": "gzip", "accept-language": "en-US"}}

      assert {:ok, pos} = ExMessageDB.write_message(id, stream_name, event, metadata)
      assert pos = 0
    end

    test "returns optimistic lock error" do
      id = UUID.generate()
      stream_name = "Account-1"
      event = TestEvent.create!(%{name: "Event 2", amount: 200})
      metadata = %{headers: %{"Accept-Encoding": "gzip", "accept-language": "en-US"}}
      wrong_position = 2

      assert {:error, message} =
               ExMessageDB.write_message(id, stream_name, event, metadata, wrong_position)

      error_message = "Wrong expected version: #{wrong_position}"
      assert String.starts_with?(message, error_message)
    end
  end

  describe "write_message/5" do
    test "returns sucessfully" do
      id = UUID.generate()
      stream_name = "Account-1"
      event = TestEvent.create!(%{name: "Event 3", amount: 300, enabled: false})
      position_lock = -1

      assert {:ok, pos} = ExMessageDB.write_message(id, stream_name, event, nil, position_lock)
      assert pos = 0
    end

    test "returns optimistic lock error" do
      id = UUID.generate()
      stream_name = "Account-1"
      event = TestEvent.create!(%{name: "Event 3", amount: 300, enabled: false})
      wrong_position = 3

      assert {:error, message} =
               ExMessageDB.write_message(id, stream_name, event, nil, wrong_position)

      error_message = "Wrong expected version: #{wrong_position}"
      assert String.starts_with?(message, error_message)
    end
  end
end
