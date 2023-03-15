defmodule Morse do
  # The Morse code alphabet represented as a map
  @morse_codes %{
    ?a => ".-",
    ?b => "-...",
    ?c => "-.-.",
    ?d => "-..",
    ?e => ".",
    ?f => "..-.",
    ?g => "--.",
    ?h => "....",
    ?i => "..",
    ?j => ".---",
    ?k => "-.-",
    ?l => ".-..",
    ?m => "--",
    ?n => "-.",
    ?o => "---",
    ?p => ".--.",
    ?q => "--.-",
    ?r => ".-.",
    ?s => "...",
    ?t => "-",
    ?u => "..-",
    ?v => "...-",
    ?w => ".--",
    ?x => "-..-",
    ?y => "-.--",
    ?z => "--..",
    ?1 => ".----",
    ?2 => "..---",
    ?3 => "...--",
    ?4 => "....-",
    ?5 => ".....",
    ?6 => "-....",
    ?7 => "--...",
    ?8 => "---..",
    ?9 => "----.",
    ?0 => "-----",
    ?\s => "..--"
  }
  def secret1(),
    do:
      '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ...'

  def secret2(),
    do:
      '.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .----'

  # The provided decoding tree
  defp decode_table do
    {:node, :na,
     {:node, 116,
      {:node, 109,
       {:node, 111, {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
        {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
       {:node, 103, {:node, 113, nil, nil},
        {:node, 122, {:node, :na, {:node, 44, nil, nil}, nil}, {:node, 55, nil, nil}}}},
      {:node, 110, {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
       {:node, 100, {:node, 120, nil, nil},
        {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
     {:node, 101,
      {:node, 97,
       {:node, 119, {:node, 106, {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}}, nil},
        {:node, 112, {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}}, nil}},
       {:node, 114, {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
        {:node, 108, nil, nil}}},
      {:node, 105,
       {:node, 117, {:node, 32, {:node, 50, nil, nil}, {:node, :na, nil, {:node, 63, nil, nil}}},
        {:node, 102, nil, nil}},
       {:node, 115, {:node, 118, {:node, 51, nil, nil}, nil},
        {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end

  @doc """
  The time complexity of this implementation is O(nm), where n is the length of the input string and m is the
  average length of the Morse code for each character. In the worst case, m is 4, which means the time complexity
  is O(4n), or simply O(n). The space complexity is also O(n), because the function is tail-recursive and does
  not consume additional stack space. This is because each character in the input text is processed exactly once,
  and each processing step takes constant time on average.

  Specifically, the encode function performs the following steps:

    Convert the input text to lowercase using String.downcase(). This takes O(n) time, where n is the length of
    the input text.

    Convert the lowercase text to a charlist using String.to_charlist(). This takes O(n) time as well because
    each character in the string needs to be converted to a Unicode codepoint in the charlist.

    Call the encode_recursive function with the empty charlist as the initial value for acc. This takes constant
    time.

    encode_recursive processes each character in the charlist exactly once. For each character, it looks up its
    Morse code in the map using Map.get(), which takes O(log k) time on average, where k is the number of keys
    in the map (in this case, 36). Since k is a constant, we can treat this lookup as a constant-time operation
    on average.

    If the Morse code string is not nil, encode_recursive concatenates it to the acc charlist using the ++ operator.
    If acc is empty, this takes O(m) time, where m is the length of the Morse code string. Otherwise, it takes
    O(m + 1) time because the ++ operator first adds a space character to the acc charlist before concatenating
    the Morse code string.

    Finally, encode_recursive returns the resulting charlist as the encoded message.

  Overall, the time complexity of the encode function is O(n) because each step takes constant time on average,
  and the longest step (the charlist concatenation in step 5) takes O(m + 1) time, where m is a constant.
  Therefore, the overall time complexity is linear in the length of the input text.
  """
  def encode(text) do
    # Convert the text to lowercase and split it into a charlist
    text
    |> String.downcase()
    |> String.to_charlist()
    # Encode the charlist recursively
    |> encode_recursive([])
  end

  # The recursive function that encodes each character
  defp encode_recursive([], acc), do: acc

  defp encode_recursive([char | rest], acc) do
    case Map.get(@morse_codes, char) do
      # If the character doesn't have a corresponding Morse code, skip it
      nil ->
        encode_recursive(rest, acc)

      # If the character has a corresponding Morse code
      morse_code ->
        case acc do
          # If this is the first character being encoded, add its Morse code to the accumulator
          [] -> encode_recursive(rest, morse_code |> String.to_charlist())
          # If this is not the first character being encoded, add a space character and the Morse code to the accumulator
          _ -> encode_recursive(rest, (acc ++ [32] ++ morse_code) |> List.to_charlist())
        end
    end
  end

  # Public function that decodes a Morse signal
  # Input:
  #   - morse_signal: a charlist containing the Morse signal to decode
  # Output:
  #   - the decoded message
  def decode(morse_signal) do
    # Build the decoding tree
    tree = decode_table()
    # Call the private decode function with the initial accumulator set to an empty list
    decode(morse_signal, tree, [])
  end

  @doc """
  The time complexity of the decode function is O(n) where n is the length of the morse_signal string.
  This is because the function calls decode_char on each element of the morse_signal string until it
  is fully decoded or until an error occurs. Since each character is only visited once and the
  decode_char function is O(1) (constant time), the time complexity of the decode function is O(n).

  The decode_char function is also O(1) because it is a simple pattern-matching operation that does
  not depend on the length of the input. Therefore, the time complexity of the entire decoding
  process is O(n).
  """
  # Private function that decodes a Morse signal using a decoding tree
  # Input:
  #   - morse_signal: charlist containing the Morse signal to decode
  #   - tree: the decoding tree, built using the decode_table/0 function
  #   - acc: the accumulator list, containing the decoded characters so far
  # Output:
  #   - list of decoded characters
  defp decode([], _, acc), do: acc

  defp decode(morse_signal, tree, acc) do
    # Call the private decode_char function with the current Morse signal and the decoding tree
    case decode_char(morse_signal, tree) do
      # If the decode_char function returns :no, it means the Morse signal cannot be decoded
      :no ->
        :io.format("error: ~w\n", [Enum.take(morse_signal, 10)])
        acc

      # If the decode_char function returns a tuple {char, rest}, it means a character was successfully decoded
      {char, rest} ->
        # Call the decode function recursively with the remaining Morse signal and the updated accumulator
        decode(rest, tree, acc ++ [char])
    end
  end

  # Private function that decodes the next character in a Morse signal using a decoding tree
  # Input:
  #   - morse_signal: binary containing the Morse signal to decode
  #   - tree: the decoding tree, built using the decode_table/0 function
  # Output:
  #   - tuple {char, rest} if a character was successfully decoded
  #   - :no if the Morse signal cannot be decoded
  defp decode_char([], {_, char, _, _}), do: {char, []}

  defp decode_char([?- | morse_signal], {_, _, long, _}) do
    # If the next signal is a dash (-), follow the long path in the decoding tree
    decode_char(morse_signal, long)
  end

  defp decode_char([?. | morse_signal], {_, _, _, short}) do
    # If the next signal is a dot (.), follow the short path in the decoding tree
    decode_char(morse_signal, short)
  end

  # If the Morse signal is empty or the decoding tree is nil, return :no
  defp decode_char(_morse_signal, nil), do: :no
  # If the next signal is a space and the decoding tree is in the "no match" state, return :no
  defp decode_char([?\s | _morse_signal], {_, :na, _, _}), do: :no
  # If the next signal is a space and the decoding tree is in a character state, return the
  # decoded character and the remaining Morse signal
  defp decode_char([?\s | morse_signal], {_, char, _, _}), do: {char, morse_signal}
end
