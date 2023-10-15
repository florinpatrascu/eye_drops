defmodule EyeDrops.TasksTest do
  use ExUnit.Case

  import ExUnit.CaptureIO
  import Mock

  setup do
    tasks = [
      %{
        id: :demo1,
        name: "demo1",
        cmd: "echo demo1",
        paths: ["lib/*"]
      },
      %{
        id: :demo2,
        name: "demo2",
        run_on_start: true,
        cmd: "echo demo2",
        paths: ["lib/*"]
      }
    ]

    {:ok, %{:tasks => tasks}}
  end

  test "Get tasks from the config with a list of ids" do
    task_ids = [:unit_tests, :acceptance]
    tasks = EyeDrops.Tasks.get(task_ids)
    assert Enum.all?(tasks, fn task -> task.id in task_ids end)
  end

  test "Get all tasks from the config" do
    task_ids = [:unit_tests, :acceptance]
    tasks = EyeDrops.Tasks.get()
    assert Enum.all?(tasks, fn task -> task.id in task_ids end)
  end

  test "Raise an exception if no tasks returned" do
    assert_raise TasksError, "No tasks found", fn ->
      EyeDrops.Tasks.get([])
    end
  end

  test "Raise an exception if no tasks defined in the config" do
    with_mock Application, get_env: fn _name, _key -> nil end do
      assert_raise TasksError, "No tasks found in test config", fn ->
        EyeDrops.Tasks.get()
      end
    end
  end

  # mock get config with empty tasks

  test "Get tasks to run if expected file has changed", %{:tasks => tasks} do
    tasks = EyeDrops.Tasks.to_run(tasks, "some/path/lib/mix/tasks/eye_drops.ex")
    assert Enum.at(tasks, 0).id == :demo1
  end

  test "No tasks to run when file event is fired", %{:tasks => tasks} do
    tasks = EyeDrops.Tasks.to_run(tasks, "some/path/.git/eye_drops.ex")
    assert tasks == []
  end

  test "No tasks to run" do
    assert EyeDrops.Tasks.exec([]) == :ok
  end

  test "Run one task with expected output", %{:tasks => tasks} do
    task = Enum.at(tasks, 0)

    printed =
      capture_io(fn ->
        EyeDrops.Tasks.exec([task])
      end)

    assert String.contains?(printed, ["Running", task.name, "Finished"])
  end

  test "Run expected tasks with expected output", %{:tasks => tasks} do
    printed =
      capture_io(fn ->
        EyeDrops.Tasks.exec(tasks)
      end)

    task1 = Enum.at(tasks, 0)
    task2 = Enum.at(tasks, 1)
    assert String.contains?(printed, ["Running", task1.name, task2.name, "Finished"])
  end

  test "Find tasks to execute when EyeDrops starts", %{:tasks => tasks} do
    start_tasks = EyeDrops.Tasks.run_on_start(tasks)
    task = Enum.at(start_tasks, 0)
    assert Enum.count(start_tasks) == 1
    assert task.id == :demo2
  end
end
