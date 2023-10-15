import Mix.Config

config :mix_test_watch,
  clear: true

config :eye_drops,
  tasks: [
    %{
      id: :unit_tests,
      run_on_start: true,
      name: "unit tests",
      cmd: "mix test",
      paths: ["E:/projects/eye_drops/lib/*"]
    }
  ]
