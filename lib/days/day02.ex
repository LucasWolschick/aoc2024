defmodule Day02 do
  @behaviour Day

  def name, do: "day02"

  defp is_safe(lst) do
    sorted_lst = Enum.sort(lst)
    is_sorted = sorted_lst == lst || Enum.reverse(sorted_lst) == lst

    deltas =
      Enum.chunk_every(lst, 2, 1, :discard)
      |> Enum.map(fn l -> abs(Enum.at(l, 0) - Enum.at(l, 1)) end)

    safe_deltas = Enum.all?(deltas, &(1 <= &1 and &1 <= 3))
    safe_deltas and is_sorted
  end

  defp parse(input) do
    String.split(input, "\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn lst -> Enum.map(lst, &elem(Integer.parse(&1), 0)) end)
    |> Enum.filter(&(!Enum.empty?(&1)))
  end

  defp removeI([], _), do: []
  defp removeI([_ | rest], 0), do: rest
  defp removeI([elem | rest], x), do: [elem] ++ removeI(rest, x - 1)

  defp remove_one(lst) do
    (Enum.with_index(lst)
     |> Enum.map(fn {_, i} -> removeI(lst, i) end)) ++ [lst]
  end

  @doc """
      iex> Day02.part1("7 6 4 2 1
      ...>              1 2 7 8 9
      ...>              9 7 6 2 1
      ...>              1 3 2 4 5
      ...>              8 6 4 4 1
      ...>              1 3 6 7 9
      ...>              ")
      "2"
  """
  def part1(input) do
    lists = parse(input)

    safe_count =
      Enum.count(lists, &is_safe/1)

    Integer.to_string(safe_count)
  end

  @doc """
      iex> Day02.part2("7 6 4 2 1
      ...>              1 2 7 8 9
      ...>              9 7 6 2 1
      ...>              1 3 2 4 5
      ...>              8 6 4 4 1
      ...>              1 3 6 7 9
      ...>              ")
      "4"
  """
  def part2(input) do
    lists = parse(input)

    safe_count =
      Enum.map(lists, &remove_one/1)
      |> Enum.map(fn options -> Enum.any?(options, &is_safe/1) end)
      |> Enum.count(& &1)

    Integer.to_string(safe_count)
  end
end
