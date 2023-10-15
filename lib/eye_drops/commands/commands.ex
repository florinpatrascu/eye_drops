defmodule EyeDrops.Commands do
  alias EyeDrops.Task
  alias EyeDrops.Tasks
  @switch_names [:include_tasks]
  @switches Enum.map(@switch_names, &{&1, :string})

  def parse([]), do: {:ok, %{}}

  def parse(args) do
    {arg_list, _, _} = OptionParser.parse(args, switches: @switches)

    switches = validate_switches!(arg_list, args)

    include_list =
      switches
      |> Keyword.get(:include_tasks, "")
      |> String.split(",")
      |> Enum.map(&String.to_atom(&1))

    {:ok, %{:include_tasks => include_list}}
  end

  @spec watch :: any
  def watch() do
    task_id = IO.gets("")
    rerun(task_id)
    :timer.sleep(:infinity)
  end

  @spec rerun(binary) :: :ok
  def rerun(task_id) do
    case to_atom(task_id) do
      :all ->
        Tasks.get()
        |> Tasks.exec()

      task_id_atom ->
        Task.to_exec(task_id_atom)
        |> Task.exec()
    end
  end

  defp to_atom(task_id) do
    atom_string = String.replace(task_id, ~r/[^a-z_]+/, "")

    atom_string
    |> String.to_atom()
  end

  defp validate_switches!([], args) do
    {_, _, not_valids} = OptionParser.parse(args, strict: [])

    Enum.each(not_valids, fn {switch, _value} ->
      raise SwitchError, message: "Invalid parameter " <> switch
    end)
  end

  defp validate_switches!(arg_list, _) do
    Enum.each(arg_list, fn {switch, value} ->
      if switch not in @switch_names do
        [argv_switch, _] = OptionParser.to_argv([{switch, value}])
        raise SwitchError, message: "Invalid parameter " <> argv_switch
      end
    end)

    arg_list
  end
end
