defmodule Day01 do
  @behaviour Day

  def name, do: "day01"

  defp lists(input) do
    pairs =
      String.split(input, "\n")
      |> Enum.map(&String.split/1)
      |> Enum.filter(fn x -> !Enum.empty?(x) end)
      |> Enum.map(&Enum.map(&1, fn x -> elem(Integer.parse(x), 0) end))
      |> Enum.map(&List.to_tuple/1)

    listA =
      Enum.map(pairs, &elem(&1, 0))
      |> Enum.sort()

    listB =
      Enum.map(pairs, &elem(&1, 1))
      |> Enum.sort()

    {listA, listB}
  end

  @doc """
      iex> Day01.part1("3   4
      ...>              4   3
      ...>              2   5
      ...>              1   3
      ...>              3   9
      ...>              3   3")
      "11"
  """
  def part1(input) do
    {listA, listB} = lists(input)

    differences =
      Enum.zip(listA, listB)
      |> Enum.map(&abs(elem(&1, 0) - elem(&1, 1)))

    Enum.sum(differences)
    |> Integer.to_string()
  end

  @doc """
      iex> Day01.part2("3   4
      ...>              4   3
      ...>              2   5
      ...>              1   3
      ...>              3   9
      ...>              3   3")
      "31"
  """
  def part2(input) do
    {listA, listB} = lists(input)

    # map listB to counts
    counts =
      Enum.reduce(listB, %{}, fn x, acc ->
        Map.update(acc, x, 1, &(&1 + 1))
      end)

    Enum.map(listA, fn x -> x * Map.get(counts, x, 0) end)
    |> Enum.sum()
    |> Integer.to_string()
  end
end
