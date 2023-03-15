defmodule Huffman do
  def sample do
    'the quick brown fox jumps over the lazy dog å ä ö
  this is a sample text that we will use when we build
  up a table we will only handle lower case letters and
  no punctuation symbols the frequency will of course not
  represent english but it is probably not that far off'
  end

  def text() do
    'this is something that we should encode'
  end

  def test do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = text()
    seq = encode(text, encode)
    decode(seq, decode)
  end

  # construct the Huffman tree from a sample text
  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  # build a sorted huffman tree. we insert one character at a time based on
  # the frequency given by freq/1
  def huffman(freq) do
    sorted = Enum.sort(freq, fn {_, x}, {_, y} -> x < y end)
    huffman_tree(sorted)
  end

  defp huffman_tree([{tree, _}]), do: tree

  defp huffman_tree([{a, af}, {b, bf} | rest]) do
    huffman_tree(insert({{a, b}, af + bf}, rest))
  end

  defp insert({a, af}, []), do: [{a, af}]

  defp insert({a, af}, [{b, bf} | rest]) when af < bf do
    [{a, af}, {b, bf} | rest]
  end

  defp insert({a, af}, [{b, bf} | rest]) do
    [{b, bf} | insert({a, af}, rest)]
  end

  # compute all the frequencies of all the characters in the sample text
  # return a list of tuples {char, freq}.
  def freq(sample) do
    freq(sample, [])
  end

  def freq([], freq) do
    freq
  end

  def freq([char | rest], freq) do
    freq(rest, update(char, freq))
  end

  defp update(char, []) do
    [{char, 1}]
  end

  defp update(char, [{char, n} | freq]) do
    [{char, n + 1} | freq]
  end

  defp update(char, [elem | freq]) do
    [elem | update(char, freq)]
  end

  # create an encoding table containing the mapping
  # from characters to codes given a Huffman tree.
  def encode_table(tree) do
    # codes(tree, [])
    # codes_better(tree, [], [])
    Enum.sort(codes_better(tree, [], []), fn {_, x}, {_, y} -> length(x) < length(y) end)
  end

  # Traverse the Huffman tree and build a binary encoding
  # for each character.
  def codes({a, b}, current_position) do
    as = codes(a, [0 | current_position])
    bs = codes(b, [1 | current_position])
    as ++ bs
  end

  def codes(a, code) do
    [{a, Enum.reverse(code)}]
  end

  # A better traversing of the tree
  def codes_better({a, b}, current_position, accumulator) do
    left = codes_better(a, [0 | current_position], accumulator)
    codes_better(b, [1 | current_position], left)
  end

  def codes_better(a, code, accumulator) do
    [{a, Enum.reverse(code)} | accumulator]
  end



  def encode_tuple(tree) do
    codes = codes(tree, [])
    sorted = Enum.sort(codes, fn {x, _}, {y, _} -> x < y end)
    extended = extend_codes(sorted, 0)
    List.to_tuple(extended)
  end

  def extend_codes([], _) do
    []
  end

  def extend_codes([{n, code} | rest], n) do
    [code | extend_codes(rest, n + 1)]
  end

  def extend_codes(codes, n) do
    [[] | extend_codes(codes, n + 1)]
  end

  def encode_tuple([], _), do: []

  def encode_tuple([char | rest], table) do
    code = elem(table, char)
    code ++ encode_tuple(rest, table)
  end

  ## An improvement where we do not waste any stack space
  # def encode_tuple(text, table) do
  #   encode_tuple(text, table, [])
  # end
  def encode_tuple([], _, acc) do
    flattenr(acc, [])
  end

  def encode_tuple([char | rest], table, acc) do
    code = elem(table, char)
    encode_tuple(rest, table, [code | acc])
  end

  def flattenr([], acc) do
    acc
  end

  def flattenr([code | rest], acc) do
    # this could further be improved if we didn't reverse the code
    flattenr(rest, code ++ acc)
  end

  # if code was stored in the reveresed order
  def add([], acc) do
    acc
  end

  def add([b | rest], acc) do
    add(rest, [b | acc])
  end

  # Parse a string of text and encode it with the
  # previously generated encoding table.
  def encode([], _), do: []

  def encode([char | rest], table) do
    {_, code} = List.keyfind(table, char, 0)
    code ++ encode(rest, table)
  end

  # Decode a string of text using the same encoding
  # table as above. This is a shortcut and an
  # unrealistic situation.

  def decode_table(tree), do: codes(tree, [])

  def decode([], _), do: []

  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)

    case List.keyfind(table, code, 1) do
      {char, _} ->
        {char, rest}

      nil ->
        decode_char(seq, n + 1, table)
    end
  end

  # # The decoder using the tree. This is a more realistic
  # # solution.

  # def decode_table(tree) do tree end

  # def decode(seq, tree) do
  #   decode(seq, tree, tree)
  # end

  def decode([], char, _) do
    [char]
  end

  def decode([0 | seq], {left, _}, tree) do
    decode(seq, left, tree)
  end

  def decode([1 | seq], {_, right}, tree) do
    decode(seq, right, tree)
  end

  def decode(seq, char, tree) do
    [char | decode(seq, tree, tree)]
  end
end
