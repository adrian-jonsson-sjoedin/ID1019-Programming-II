
defmodule Hanoi do
  @moduledoc """
  The code defines a module Hanoi which implements a solution for the classic Towers of Hanoi puzzle.

  The puzzle consists of three rods and a number of disks of different sizes, which can slide onto any rod.
  The puzzle starts with the disks in a neat stack in ascending order of size on one rod, the smallest at
  the top, thus making a conical shape. The objective of the puzzle is to move the entire stack to another
  rod, obeying the following simple rules:

  1. Only one disk can be moved at a time.
  2. Each move consists of taking the upper disk from one of the stacks and placing it on top of another
     stack or on an empty rod.
  3. No disk may be placed on top of a smaller disk.
  """
  #base case when number of disk are zero. Will act as the termination condition for the recursion
  def hanoi(0, _, _, _) do [] end
  #when we have 1 r more disks to move we use recursion.
  #a: name of the source rod
  #b: name of the auxiliary rod
  #c: name of the target rod
  @doc """
  Is a recursive function that calculates the series of moves needed to solve the Towers of Hanoi puzzle with n disks.
  The function works as follows:
    1.The first step is to move n-1 disks from the source rod a to the auxiliary rod b, using the target rod c as an
      auxiliary. This is done by making a recursive call to hanoi/4 with n-1 as the number of disks, a as the source
      rod, c as the target rod, and b as the auxiliary rod. The result of this call is a list of moves needed to
      accomplish this task.

    2.The next step is to move the nth disk from the source rod a to the target rod c. This move is represented by the
    tuple {:move, a, c}.

    3.The final step is to move the n-1 disks from the auxiliary rod b to the target rod c, using the source rod a as an
    auxiliary. This is done by making another recursive call to hanoi/4 with n-1 as the number of disks, b as the source
    rod, a as the auxiliary rod, and c as the target rod. The result of this call is another list of moves.

    The final result of the function is the concatenation of the results of these three steps, which is done using the ++
    operator. The result is a list of moves needed to solve the puzzle with n disks, starting from the source rod a and
    ending on the target rod c.

    By repeating these steps for smaller and smaller values of n, the function builds up a solution to the puzzle by
    solving sub-problems, eventually reaching the base case where n is 0.
  """
  # source, aux, target
  def hanoi(numb_of_disks, a, b, c) do
    hanoi(numb_of_disks-1, a, c, b) ++ [{:move, a, c}] ++ hanoi(numb_of_disks-1, b, a, c)
  end
  @doc """
  calculates the numbers of moves required to solve the puzzle for a given size
  """
  def hanoi_moves(tower_size) do
    :math.pow(2, tower_size) - 1
  end
end
