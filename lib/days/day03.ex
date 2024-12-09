defmodule Day03 do
  @behaviour Day

  def parse_int_within_size(str) do
    case Integer.parse(str) do
      {int, rest} when (byte_size(str) - byte_size(rest)) in 1..3 -> {int, rest}
      _ -> :error
    end
  end

  def parse(""), do: []

  def parse("mul(" <> rest) do
    {lhs, rest} = parse_int_within_size(rest)
    "," <> rest = rest
    {rhs, rest} = parse_int_within_size(rest)
    ")" <> rest = rest
    [{lhs, rhs}] ++ parse(rest)
  rescue
    _ -> parse(rest)
  end

  def parse(<<_::utf8, rest::binary>>), do: parse(rest)

  def parse_smart(""), do: []

  def parse_smart("mul(" <> rest) do
    {lhs, rest} = parse_int_within_size(rest)
    "," <> rest = rest
    {rhs, rest} = parse_int_within_size(rest)
    ")" <> rest = rest
    [{lhs, rhs}] ++ parse_smart(rest)
  rescue
    _ -> parse_smart(rest)
  end

  def parse_smart("don't()" <> rest) do
    parse_dumb(rest)
  end

  def parse_smart(<<_::utf8, rest::binary>>), do: parse_smart(rest)

  def parse_dumb(""), do: []

  def parse_dumb("do()" <> rest) do
    parse_smart(rest)
  end

  def parse_dumb(<<_::utf8, rest::binary>>), do: parse_dumb(rest)

  def name, do: "day03"

  @doc """
      iex> Day03.part1("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")
      "161"
  """
  def part1(input) do
    parse(input) |> Enum.map(&Tuple.product/1) |> Enum.sum() |> Integer.to_string()
  end

  @doc """
      iex> Day03.part2("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")
      "161"
  """
  def part2(input) do
    parse_smart(input) |> Enum.map(&Tuple.product/1) |> Enum.sum() |> Integer.to_string()
  end
end
