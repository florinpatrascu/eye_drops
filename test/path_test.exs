defmodule EyeDrops.File.PathTest do
  use ExUnit.Case
  alias EyeDrops.File.Path

  test "Path exists" do
    result = Path.exists?("lib/mix/tasks/eye_drops.ex")
    assert result == true
  end

  test "Changed file matches single path from task" do
    result = Path.spotted?("/some/random/lib/eye_drops.ex", "lib/eye_drops.ex")
    assert result == true
  end

  test "Changed file matches list of paths from task" do
    result =
      Path.spotted?("random/lib/mix/tasks/eye_drops.ex", [
        "lib/mix/tasks/eye_drops.ex",
        "lib/other.ex"
      ])

    assert result == true
  end

  test "Changed file matches list of wildcard paths from task" do
    result = Path.spotted?("lib/mix/tasks/eye_drops.ex", ["lib/mix/tasks/*", "test/other.ex"])
    assert result == true
  end

  test "Changed file matches wildcard path from task" do
    result = Path.spotted?("projects/eye_drops/lib/mix/tasks/eye_drops.ex", "lib/*")
    assert result == true
  end

  test "Changed file does not match wildcard path from task" do
    result = Path.spotted?("/some/lib/random/eye_drops.ex", "lib/test")
    assert result == false
  end

  test "Changed file does not match list of paths from task" do
    result = Path.spotted?("/some/random/lib/eye_drops.ex", ["other/*", "test/somewhere.ex"])
    assert result == false
  end
end
