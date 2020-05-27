defmodule ExMessageDbTest do
  @moduledoc false
  use ExMessageDb.RepoCase
  alias ExMessageDb

  describe "message_store_version/0" do
    test "returns current version" do
      assert {:ok, "1.2.3"} = ExMessageDb.message_store_version()
    end
  end
end
