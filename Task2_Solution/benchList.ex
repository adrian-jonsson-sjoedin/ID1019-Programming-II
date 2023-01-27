defmodule BenchList do
  def bench(), do: bench(1000)

  def bench(n) do
    ls = [16, 32, 64, 128, 256, 512, 1024, 2 * 1024, 4 * 1024, 8 * 1024, 16 * 1024, 32 * 1024]

    :io.format("# List benchmark with ~w operations, time per operation in us\n", [n])
    :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])

    Enum.each(ls, fn i ->
      {i, time_add, time_lookup, time_remove} = bench(i, n)
      :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, time_add / n, time_lookup / n, time_remove / n])
    end)
  end

  def bench(i, n) do
    seq = Enum.map(1..i, fn _ -> :rand.uniform(i) end)
    list = Enum.reduce(seq, EnvList.new(), fn e, list -> EnvList.add(list, e, :foo) end)

    seq = Enum.map(1..n, fn _ -> :rand.uniform(i) end)
    {add, _} = :timer.tc(fn -> Enum.each(seq, fn e -> EnvList.add(list, e, :foo) end) end)
    {lookup, _} = :timer.tc(fn -> Enum.each(seq, fn e -> EnvList.lookup(list, e) end) end)
    {remove, _} = :timer.tc(fn -> Enum.each(seq, fn e -> EnvList.remove(list, e) end) end)
    {i, add, lookup, remove}
  end
end
