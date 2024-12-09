defmodule Day do
  @callback name() :: String.t()
  @callback part1(String.t()) :: String.t()
  @callback part2(String.t()) :: String.t()
end

defmodule Runner do
  def load() do
    "lib/days"
    |> File.ls!()
    |> Enum.filter(&String.ends_with?(&1, ".ex"))
    |> Enum.each(&Code.require_file("lib/days/#{&1}"))
  end

  def run_all() do
    :code.all_loaded()
    |> Enum.map(&elem(&1, 0))
    |> Enum.filter(&module_implements_day?/1)
    |> Enum.map(& &1.name())
    |> Runner.run()
  end

  def run(module_names) do
    :code.all_loaded()
    |> Enum.map(&elem(&1, 0))
    |> Enum.filter(&module_implements_day?/1)
    |> Enum.filter(fn module -> module.name() in module_names end)
    |> Enum.each(&run_day(&1, File.read!("input/#{&1.name()}.txt")))
  end

  defp module_implements_day?(module) do
    Code.ensure_loaded?(module) and
      function_exported?(module, :name, 0) and
      function_exported?(module, :part1, 1) and
      function_exported?(module, :part2, 1)
  end

  defp run_day(module, input) do
    IO.puts("== #{module.name()} ==")

    result1 = module.part1(input)
    IO.puts("1: #{result1}")

    result2 = module.part2(input)
    IO.puts("2: #{result2}")
  end
end

defmodule Aoc2024 do
  def main do
    Runner.load()

    case System.argv() do
      [] -> Runner.run_all()
      args -> Runner.run(args)
    end
  end
end
