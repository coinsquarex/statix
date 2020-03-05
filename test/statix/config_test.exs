defmodule Statix.ConfigTest do
  use Statix.TestCase, async: false

  use Statix, runtime_config: true

  test "global tags when present" do
    Application.put_env(:statix, :tags, ["tag:test"])

    connect()

    increment("sample", 3)
    assert_receive {:test_server, "sample:3|c|#tag:test"}

    increment("sample", 3, tags: ["foo"])
    assert_receive {:test_server, "sample:3|c|#foo,tag:test"}
  after
    Application.delete_env(:statix, :tags)
  end

  test "global connection-specific tags" do
    Application.put_env(:statix, __MODULE__, tags: ["tag:test"])

    connect()

    increment("sample", 3)
    assert_receive {:test_server, "sample:3|c|#tag:test"}

    increment("sample", 3, tags: ["foo"])
    assert_receive {:test_server, "sample:3|c|#foo,tag:test"}
  after
    Application.delete_env(:statix, __MODULE__)
  end
end
