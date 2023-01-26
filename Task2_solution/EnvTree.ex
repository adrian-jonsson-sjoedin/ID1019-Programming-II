defmodule EnvTree do
  def new(), do: nil

  # REMEMBER WE SORT BY KEY, NOT VALUE! :A < :a and :a < :aa
  # When empty we add the new pair
  def add(nil, key, value) do
    {:node, key, value, nil, nil}
  end

  # if the key already exists we replace it
  def add({:node, key, _, left, right}, key, value) do
    {:node, key, value, left, right}
  end

  # return a tree that looks like the one we have but where the left branch has been updated
  def add({:node, k, v, left, right}, key, value) when k < key do
    {:node, k, v, add(left, key, value), right}
  end

  # same as above but we update the right branch when the new key is bigger
  def add({:node, k, v, left, right}, key, value) do
    {:node, k, v, left, add(right, key, value)}
  end

  # if key not found we return nil
  def lookup(nil, _), do: nill
  # we've found the key
  def lookup({:node, key, value, _, _}, key) do
    {key, value}
  end

  # if the key we're searching for is larger than where we're at we go down left
  def lookup({:node, k, _, left, _}, key) when k < key do
    lookup(left, key)
  end

  # else we go down right
  def lookup({:node, _, _, _, right}, key) do
    lookup(right, key)
  end
  #if the tree is empty
  def remove(nil, _), do: nil
  #if the pair is found and it doesn't have anything on the left we remove it and move right up
  def remove({:node, key, _, nil, right}, key), do: right
  #same but for the opposite
  def remove({:node, key, _, left, nil}, key), do: left
end
