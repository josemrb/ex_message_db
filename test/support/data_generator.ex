defmodule ExMessageDB.DataGenerator do
  @moduledoc """
  Helper functions to generate test data.
  """

  @amount_range_start 1
  @amount_range_end 1_000
  @amount_list Range.new(@amount_range_start, @amount_range_end)
               |> Enum.to_list()
               |> Enum.filter(fn x -> rem(x, 10) == 0 end)
  def random_amount do
    Enum.random(@amount_list)
  end

  def random_boolean do
    random_integer()
    |> Integer.mod(2)
    |> Kernel.==(0)
  end

  @integer_lower_limit 1
  @integer_upper_limit 1_000
  def random_integer do
    random_integer(@integer_lower_limit, @integer_upper_limit)
  end

  def random_integer(lower_limit, upper_limit) do
    lower_limit + :rand.uniform(upper_limit - lower_limit + 1) - 1
  end
end
