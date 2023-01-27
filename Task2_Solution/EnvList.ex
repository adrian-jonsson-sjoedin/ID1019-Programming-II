defmodule EnvList do
  def new(), do: []
  #base case when map is empty
  def add([], key, value) do
    [{key, value}]
  end
  #if the key we want to add already exists, change the value
  def add([{key, _} | map], key, value) do
    [{key, value} | map]
  end
  # add a new pair to a non empty map
  def add([head | map], key, value) do
    [head | add(map, key, value)] #this line will execute the add on line 12 multiple times before eventually executing add
  end                             #on line 4 where a new pair is going to be added
  #if the map is empty
  def lookup([], _key), do: nil
  #if the key is in the map
  def lookup([{key, _value}=pair | _], key), do: pair
  #when it is not the key we are looking for, we call lookup again until we either find it or the map is empty
  def lookup([_ | map], key), do: lookup(map, key)
  #when map is empty
  def remove([], _), do: nil
  #when we find the key
  def remove([{key, _} | map], key) do map end
  #when we need to keep searching for the key
  def remove([head|map], key) do [head | remove(map, key)] end
end
