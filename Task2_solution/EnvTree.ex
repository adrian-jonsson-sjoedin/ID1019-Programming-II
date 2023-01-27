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
  def add({:node, k, v, left, right}, key, value) when key < k do
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

  # if the key we're searching for is smaller than where we're at we go down left
  def lookup({:node, k, _, left, _}, key) when key < k do
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
  #if the key is found but it have branches down left and right, we have to replace it with
  #the leftmost pair in the right branch
  def remove({:node, key, _, left, right}, key) do
    {key, value, rest} = leftmost(right) #pattern match with what leftmost returns
    {:node, key, value, left, rest}
  end
  #when the key we want to remove is smaller than where we're at we go down left and look
  def remove({:node, k, v, left, right}, key) when key < k do
    {:node, k, v, remove(left, key), right}
  end
  #if it's larger than where we're at we go down right
  def remove({:node, k, v, left, right}, key) do
    {:node, k, v, left, remove(right, key)}
  end

  #if the right branch doesn't have a left branch we can simply return
  def leftmost({:node, key, value, nil, rest}) do
    {key, value, rest}
  end
  #otherwise we keep going recursively until we find one that has
  def leftmost({:node, k, v, left, right}) do
    {key, value, rest} = leftmost(left)
    {key, value, {:node, k, v, rest, right}}
  end
end
