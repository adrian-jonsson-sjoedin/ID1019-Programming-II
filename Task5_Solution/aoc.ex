defmodule AOC do
  @doc """
  Parse input.
  """
  def parse(puzzle_input) do
    puzzle_input
    |> String.trim()          # Remove leading/trailing white space
    |> String.split("\n\n")   # Split by double line break into list of elves
    |> Enum.map(fn elf ->
         elf
         |> String.split("\n")   # Split elf inventory by line into list of strings
         |> Enum.map(&String.to_integer/1)  # Convert string list to integer list
       end)
  end

  @doc """
  Solve the problem.
  Example output
  {{24000, [7000, 8000, 9000]}, 4}
  total calories 24000, calories per item in inventory, elf number 4
  """
  # def solve(path) do
  #   File.read!(path)                  # Read file contents
  #   |> parse()                        # Parse the inventory
  #   |> Enum.map(&{Enum.sum(&1), &1})  # Map each elf's inventory to a tuple of (total calories, inventory)
  #   |> Enum.with_index(1)             # Add 1 to the index of each tuple
  #   |> Enum.max_by(&elem(&1, 0))      # Find the tuple with the highest total calories, and return it
  # end

  # Example output
  # {[24000], 4}
  # Total calories and elf number
  def solve(path) do
    File.read!(path)                  # Read file contents
    |> parse()                        # Parse the inventory
    |> Enum.map(&[Enum.sum(&1)])      # Map each elf's inventory to a list of the total calories
    |> Enum.with_index(1)             # Add 1 to the index of each list
    |> Enum.max_by(&elem(&1, 0))      # Find the list with the highest total calories, and return it
  end

end
