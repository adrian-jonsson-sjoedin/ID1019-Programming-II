defmodule Shunt do
  # This function takes two lists as arguments, xs and ys.
  def find([], []) do
    # If both lists are empty, we return an empty list.
    []
  end

  # If xs is not empty and ys is not empty, we call this function.
  # We pattern match on ys to get its first element y and the rest of the list ys.
  def find(xs, [y | ys]) do
    # We split xs into two lists, hs and ts, using the Train.split function with y as the pivot.
    {hs, ts} = Train.split(xs, y)
    # We calculate the length of hs and ts.
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

  # This function takes two lists as arguments, xs and ys.
  # If both lists are empty, it returns an empty list.
  # If xs is not empty and ys is not empty, it splits xs into two lists, hs and ts, using the Train.split function with y as the pivot.
  # It creates a list of moves based on hs and ts, and recursively calls few/2 on the updated train and ys.
  def few([], []) do
    []
  end

  # If xs is not empty and ys is not empty, we call this function.
  # We pattern match on ys to get its first element y and the rest of the list ys.
  def few(xs, [y | ys]) do
    # We split xs into two lists, hs and ts, using the Train.split function with y as the pivot.
    {hs, ts} = Train.split(xs, y)
    # We calculate the length of hs and ts.
    n_hs = length(hs)
    n_ts = length(ts)

    # We create a list of moves based on the lengths of hs and ts, like in the find/2 function above.
    moves = [
      {:one, n_ts + 1},
      {:two, n_hs},
      {:one, -(n_ts + 1)},
      {:two, -n_hs}
    ]

    # If hs is empty (i.e. its length is zero), we recursively call few/2 on ts and ys and return the result.
    # If hs is not empty, we recursively call few/2 on ts ++ hs and ys, and concatenate the moves with the result.
    if n_hs == 0 do
      [] ++ few(ts, ys)
    else
      moves ++ few(ts ++ hs, ys)
    end
  end

  # This function takes a list of moves, ms, as input.
  # It applies the rules to ms until the resulting list of moves no longer changes.
  # This function is unnecessary since the few/2 function already does this. Can use it on find/2 though.
  def compress(ms) do
    # We apply the rules to ms.
    ns = rules(ms)
    # If the resulting list of moves is the same as the input list of moves, we return the input list.
    if ns == ms do
      ms
      # If the resulting list of moves is different from the input list of moves, we recursively call compress/1 on the new list.
    else
      compress(ns)
    end
  end

  # This function takes an empty list as input and returns an empty list.
  def rules([]) do
    []
  end

  # This function takes a non-empty list of moves as input, where each move is a tuple of the form {:track, step}.
  # It applies the rules to the first move in the list and recursively applies the rules to the remaining moves.
  def rules([{track, step} | moves]) do
    # We use a cond expression to pattern match on the value of step and moves.
    cond do
      # If step is 0, we discard the current move and recursively apply the rules to the remaining moves.
      step == 0 ->
        rules(moves)

      # If there are more moves in the list, we pattern match on the next move and apply the appropriate rule.
      moves != [] ->
        [{nextTrack, nextStep} | nextMoves] = moves
        cond do
          # If the current track and the next track are both :one, we merge the moves and recursively apply the rules to the remaining moves.
          track == :one && nextTrack == :one ->
            [{:one, step + nextStep}] ++ rules(nextMoves)
          # If the current track and the next track are both :two, we merge the moves and recursively apply the rules to the remaining moves.
          track == :two && nextTrack == :two ->
            [{:two, step + nextStep}] ++ rules(nextMoves)
          # If the current track and the next track are different, we keep the current move and recursively apply the rules to the remaining moves.
          true ->
            [{track, step}] ++ rules(moves)
        end
      # If there are no more moves in the list, we keep the current move and return it.
      true ->
        [{track, step}] ++ rules(moves)
    end
  end
end
