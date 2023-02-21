defmodule PiEstimator do
@moduledoc """
This module estimates the value of pi using the Monte Carlo method. The Monte
Carlo method is a statistical approach that uses random sampling to obtain
numerical results. The estimation of pi is done by generating random points
inside a circle inscribed in a square, and then counting the number of points
that fall inside the circle. This count is then used to estimate the value of
pi.

To use this module, call the rounds/3 function with the following parameters:

- `k`: the number of rounds to perform; each round doubles the number of darts
  thrown
- `j`: the number of darts to throw in each round
- `r`: the radius of the circle used for estimation

This will print out an estimate of pi for each round, along with the error
compared to the actual value of pi.
"""

@doc """
Simulates the throwing of a single dart at a target of the given radius.
Returns true if the dart lands inside the circle, false otherwise.

## Parameters

- `r`: the radius of the circle

## Example

    iex> PiEstimator.dart(5)
    true
"""
def dart(r) do
  x = :rand.uniform(r)
  y = :rand.uniform(r)
  x * x + y * y <= r * r
end

@doc """
Simulates a single round of dart-throwing, and returns the number of darts that
landed inside the circle.

## Parameters

- `k`: the number of darts to throw
- `r`: the radius of the circle
- `a`: the accumulated number of darts that landed inside the circle in previous
  rounds

## Example

    iex> PiEstimator.round(100, 5, 0)
    83
"""
def round(0, _, a) do
  a
end

def round(k, r, a) do
  if dart(r) do
    round(k-1, r, a+1)
  else
    round(k-1, r, a)
  end
end

@doc """
Simulates multiple rounds of dart-throwing to estimate the value of pi, and prints
out the estimate and error for each round.

## Parameters

- `k`: the number of rounds to perform
- `j`: the number of darts to throw in each round
- `r`: the radius of the circle

## Example

    iex> PiEstimator.rounds(5, 1000, 5)
    Estimate: 3.172 (error: 0.031415926535897934)
    Estimate: 3.132 (error: 0.008815926535897934)
    Estimate: 3.148 (error: 0.004965926535897934)
    Estimate: 3.143 (error: 0.0008159265358979341)
    Estimate: 3.141 (error: 1.5926535897934e-05)
"""
# This function is the entry point for estimating the value of pi using Monte Carlo simulation. It takes the
# parameters specified above
  def rounds(k, j, r) do
    rounds(k, j, 0, r, 0)#Initializes the first round of darts, by calling the rounds/5 function
  end
  # This function is called by the rounds/5 function below when the specified number of rounds have been completed.
  # It takes five parameters:
  #   0: the number of rounds remaining, which will be 0
  #   _: a discard variable for the j parameter that is not used in this case
  #   t: the total number of darts thrown so far
  #   _: a discard variable for the r parameter that is not used in this case
  #   a: the total number of darts that have landed inside the circle so far
  defp rounds(0, _, t, _, a) do
    IO.puts("Estimate: #{4.0 * a / t}")#Print the final estimate of pi, based on the total number of darts thrown and the number that landed inside the circle
  end

  # This function calls the round/3 function to throw a number of darts and count the number that land inside the circle.
  # It then updates the total number of darts thrown and the total number that have landed inside the circle, calculates
  # the current estimate of pi, and prints it out, along with the error compared to the actual value of pi. Finally, it
  # recursively calls itself with the j parameter doubled, until the specified number of rounds have been completed.
  # It takes five parameters:
  # k: the number of rounds remaining
  # j: the number of darts to throw in this round
  # t: the total number of darts thrown so far
  # r: the radius of the circle used for estimation
  # a: the total number of darts that have landed inside the circle so far
  defp rounds(k, j, t, r, a) do
    a = round(j, r, a)
    t = t + j
    pi = 4.0 * a / t #Calculate the estimate of pi based on the current round's darts and all previously thrown darts
    IO.puts("Estimate: #{pi} (error: #{pi - :math.pi()})")
    rounds(k-1, j*2, t, r, a) # Recursive call to perform the next round with double the number of darts
  end
end

# PiEstimator.rounds(10, 100000, 10000) gives me pi to 3-4 decimals
# PiEstimator.rounds(10, 1000000, 100000) gives me pi to 4 decimals
