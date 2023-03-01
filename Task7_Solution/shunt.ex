defmodule Shunt do
  def find([], []) do
    []
  end

  def find(xs, [y | ys]) do
    {hs, ts} = Train.split(xs, y)
    n_hs = length(hs)
    n_ts = length(ts)
    # using list comprehension
    # {:one, n_ts+1}: Move tn+1 wagons from the right end of the main track to track one, including wagon y.
    # {:two, n_hs}: Move hn wagons from the left end of the main track to track two.
    # {:one, -(n_ts+1)}: Move the wagons from track one back to the main track, in reverse order (i.e., the
    # rightmost wagon on track one becomes the leftmost wagon on the main track).
    # {:two, -n_hs}: Move the wagons from track two back to the main track, in the same order they were on
    # track two.
    # We concatenate this sequence of moves with the result of recursively calling find/2 on the updated
    # train, which is obtained by appending hs and ts (in that order) and passing it as the first argument
    # to find/2.
    [
      {:one, n_ts + 1},
      {:two, n_hs},
      {:one, -(n_ts + 1)},
      {:two, -n_hs} | find(Train.append(hs, ts), ys)
    ]
  end

  def few([], []) do
    []
  end

  def few(xs, [y | ys]) do
    {hs, ts} = Train.split(xs, y)

    moves = [
      {:one, 1 + count(ts)},
      {:two, count(hs)},
      {:one, -(1 + count(ts))},
      {:two, -count(hs)}
    ]

    if count(hs) == 0 do
      [] ++ few(ts, ys)
    else
      moves ++ few(ts ++ hs, ys)
    end
  end

  defp count(train) do
    do_count(train, 0)
  end

  defp do_count([], acc), do: acc
  defp do_count([_ | tail], acc), do: do_count(tail, acc + 1)
end
