defmodule ExMessageDBTest do
  @moduledoc """
  Message DB client tests.
  """

  use ExMessageDB.RepoCase

  describe "get_category_messages/1" do
    test "when category is empty returns sucessfully" do
      category_name = "category"

      assert [] == ExMessageDB.get_category_messages(category_name)
    end

    test "when stream contains elements returns sucessfully" do
      category_name = "category"
      messages_attrs = build_list(3, :message, %{category_name: category_name})
      Enum.map(messages_attrs, fn message_attrs -> ExMessageDB.write_message(message_attrs) end)

      result_list = ExMessageDB.get_category_messages(category_name)

      assert length(result_list) == 3
      assert %{message: %Message{} = message} = List.first(result_list)
      assert String.starts_with?(message.stream_name, category_name)
    end

    test "returns category name error" do
      stream_name = "category-x"

      assert {:error, result_message} = ExMessageDB.get_category_messages(stream_name)

      error_message = "Must be a category: #{stream_name}"
      assert String.starts_with?(result_message, error_message)
    end
  end

  describe "get_category_messages/2" do
    setup do
      Repo.query!("ALTER SEQUENCE messages_global_position_seq RESTART WITH 1")
      :ok
    end

    test "when category is empty returns sucessfully" do
      category_name = "category"
      position = 2

      assert [] == ExMessageDB.get_category_messages(category_name, position)
    end

    test "when category contains elements returns sucessfully" do
      category_name = "category"
      messages_attrs = build_list(5, :message, %{category_name: category_name})
      Enum.map(messages_attrs, fn message_attrs -> ExMessageDB.write_message(message_attrs) end)

      position = 3
      result_list = ExMessageDB.get_category_messages(category_name, position)

      assert length(result_list) == 3
      assert %{message: %Message{} = message} = List.first(result_list)
      assert String.starts_with?(message.stream_name, category_name)
    end

    test "returns category name error" do
      stream_name = "category-x"
      position = 2

      assert {:error, result_message} = ExMessageDB.get_category_messages(stream_name, position)

      error_message = "Must be a category: #{stream_name}"
      assert String.starts_with?(result_message, error_message)
    end
  end

  describe "get_category_messages/3" do
    setup do
      Repo.query!("ALTER SEQUENCE messages_global_position_seq RESTART WITH 1")
      :ok
    end

    test "when category is empty returns sucessfully" do
      category_name = "category"
      position = 2
      batch_size = 10

      assert [] == ExMessageDB.get_category_messages(category_name, position, batch_size)
    end

    test "when category contains elements returns sucessfully" do
      category_name = "category"
      messages_attrs = build_list(10, :message, %{category_name: category_name})
      Enum.map(messages_attrs, fn message_attrs -> ExMessageDB.write_message(message_attrs) end)

      position = 3
      batch_size = 5
      result_list = ExMessageDB.get_category_messages(category_name, position, batch_size)

      assert length(result_list) == 5
      assert %{message: %Message{} = message} = List.first(result_list)
      assert String.starts_with?(message.stream_name, category_name)
    end

    test "returns category name error" do
      stream_name = "category-x"
      position = 2
      batch_size = 5

      assert {:error, result_message} =
               ExMessageDB.get_category_messages(stream_name, position, batch_size)

      error_message = "Must be a category: #{stream_name}"
      assert String.starts_with?(result_message, error_message)
    end
  end

  describe "get_last_stream_message/1" do
    test "when stream is empty returns sucessfully" do
      stream_name = "category-x"

      assert nil == ExMessageDB.get_last_stream_message(stream_name)
    end

    test "when stream contains elements returns sucessfully" do
      stream_name = "category-x"
      messages_attrs = build_list(3, :message, %{stream_name: stream_name})
      Enum.map(messages_attrs, fn message_attrs -> ExMessageDB.write_message(message_attrs) end)

      assert %{message: %Message{} = message} = ExMessageDB.get_last_stream_message(stream_name)
      assert message.stream_name == stream_name
    end
  end

  describe "get_stream_messages/1" do
    test "when stream is empty returns sucessfully" do
      stream_name = "category-x"

      assert [] == ExMessageDB.get_stream_messages(stream_name)
    end

    test "when stream contains elements returns sucessfully" do
      stream_name = "category-x"
      messages_attrs = build_list(3, :message, %{stream_name: stream_name})
      Enum.map(messages_attrs, fn message_attrs -> ExMessageDB.write_message(message_attrs) end)

      result_list = ExMessageDB.get_stream_messages(stream_name)

      assert length(result_list) == 3
      assert %{message: %Message{} = message} = List.first(result_list)
      assert message.stream_name == stream_name
    end

    test "returns stream name error" do
      category_name = "category"

      assert {:error, result_message} = ExMessageDB.get_stream_messages(category_name)

      error_message = "Must be a stream name: #{category_name}"
      assert String.starts_with?(result_message, error_message)
    end
  end

  describe "get_stream_messages/2" do
    test "when stream is empty returns sucessfully" do
      stream_name = "category-x"
      position = 2

      assert [] == ExMessageDB.get_stream_messages(stream_name, position)
    end

    test "when stream contains elements returns sucessfully" do
      stream_name = "category-x"
      messages_attrs = build_list(5, :message, %{stream_name: stream_name})
      Enum.map(messages_attrs, fn message_attrs -> ExMessageDB.write_message(message_attrs) end)

      position = 3
      result_list = ExMessageDB.get_stream_messages(stream_name, position)

      assert length(result_list) == 2
      assert %{message: %Message{} = message} = List.first(result_list)
      assert message.stream_name == stream_name
    end

    test "returns stream name error" do
      category_name = "category"
      position = 2

      assert {:error, result_message} = ExMessageDB.get_stream_messages(category_name, position)

      error_message = "Must be a stream name: #{category_name}"
      assert String.starts_with?(result_message, error_message)
    end
  end

  describe "get_stream_messages/3" do
    test "when stream is empty returns sucessfully" do
      stream_name = "category-x"
      position = 2
      batch_size = 10

      assert [] == ExMessageDB.get_stream_messages(stream_name, position, batch_size)
    end

    test "when stream contains elements returns sucessfully" do
      stream_name = "category-x"
      messages_attrs = build_list(10, :message, %{stream_name: stream_name})
      Enum.map(messages_attrs, fn message_attrs -> ExMessageDB.write_message(message_attrs) end)

      position = 3
      batch_size = 5
      result_list = ExMessageDB.get_stream_messages(stream_name, position, batch_size)

      assert length(result_list) == 5
      assert %{message: %Message{} = message} = List.first(result_list)
      assert message.stream_name == stream_name
    end

    test "returns stream name error" do
      category_name = "category"
      position = 2
      batch_size = 5

      assert {:error, result_message} =
               ExMessageDB.get_stream_messages(category_name, position, batch_size)

      error_message = "Must be a stream name: #{category_name}"
      assert String.starts_with?(result_message, error_message)
    end
  end

  describe "message_store_version/0" do
    test "returns current version sucessfully" do
      assert "1.2.3" = ExMessageDB.message_store_version()
    end
  end

  describe "write_message/1" do
    test "returns sucessfully" do
      message_attrs = build(:message)

      assert {:ok, position} = ExMessageDB.write_message(message_attrs)
      assert position == 0
    end

    test "returns optimistic lock error" do
      wrong_version = 1
      message_attrs = build(:message, %{expected_version: wrong_version})

      assert {:error, result_message} = ExMessageDB.write_message(message_attrs)

      error_message = "Wrong expected version: #{wrong_version}"
      assert String.starts_with?(result_message, error_message)
    end
  end

  describe "write_message/3" do
    test "returns sucessfully" do
      %{id: id, stream_name: stream_name, data: embedded_schema} = build(:message)

      assert {:ok, position} = ExMessageDB.write_message(id, stream_name, embedded_schema)
      assert position == 0
    end

    test "returns optimistic lock error" do
      %{id: id, stream_name: stream_name, data: embedded_schema} = build(:message)
      wrong_version = 1

      assert {:error, result_message} =
               ExMessageDB.write_message(id, stream_name, embedded_schema, nil, wrong_version)

      error_message = "Wrong expected version: #{wrong_version}"
      assert String.starts_with?(result_message, error_message)
    end
  end

  describe "write_message/4" do
    test "returns sucessfully" do
      %{id: id, stream_name: stream_name, data: embedded_schema} = build(:message)
      metadata = %{headers: %{"Accept-Encoding": "gzip", "accept-language": "en-US"}}

      assert {:ok, position} =
               ExMessageDB.write_message(id, stream_name, embedded_schema, metadata)

      assert position == 0
    end

    test "returns optimistic lock error" do
      %{id: id, stream_name: stream_name, data: embedded_schema} = build(:message)
      metadata = %{headers: %{"Accept-Encoding": "gzip", "accept-language": "en-US"}}
      wrong_version = 2

      assert {:error, result_message} =
               ExMessageDB.write_message(
                 id,
                 stream_name,
                 embedded_schema,
                 metadata,
                 wrong_version
               )

      error_message = "Wrong expected version: #{wrong_version}"
      assert String.starts_with?(result_message, error_message)
    end
  end

  describe "write_message/5" do
    test "returns sucessfully" do
      %{id: id, stream_name: stream_name, data: embedded_schema} = build(:message)
      expected_version = -1

      assert {:ok, position} =
               ExMessageDB.write_message(id, stream_name, embedded_schema, nil, expected_version)

      assert position == 0
    end

    test "returns optimistic lock error" do
      %{id: id, stream_name: stream_name, data: embedded_schema} = build(:message)
      wrong_position = 3

      assert {:error, result_message} =
               ExMessageDB.write_message(id, stream_name, embedded_schema, nil, wrong_position)

      error_message = "Wrong expected version: #{wrong_position}"
      assert String.starts_with?(result_message, error_message)
    end
  end
end
