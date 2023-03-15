defmodule Morse do
  def morse_tree do
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

  def encode_table, do: build_encode_table(morse_tree(), "")

  defp build_encode_table(nil, _), do: %{}

  defp build_encode_table({:node, :na, left, right}, current_code) do
    Map.merge(
      build_encode_table(left, current_code <> "."),
      build_encode_table(right, current_code <> "-")
    )
  end

  defp build_encode_table({:node, char, left, right}, current_code) do
    Map.merge(
      %{char => current_code},
      Map.merge(
        build_encode_table(left, current_code <> "."),
        build_encode_table(right, current_code <> "-")
      )
    )
  end

  def encode(text) do
    table = encode_table()

    text
    |> String.downcase()
    |> String.to_charlist()
    |> Enum.map(fn c -> Map.get(table, c, "") end)
    |> Enum.join(" ")
    |> String.trim()
  end


  def decode_table, do: build_decode_table(morse_tree(), "")

  defp build_decode_table(nil, _), do: %{}

  defp build_decode_table({:node, :na, left, right}, current_code) do
    Map.merge(
      build_decode_table(left, current_code <> "."),
      build_decode_table(right, current_code <> "-")
    )
  end

  defp build_decode_table({:node, char, left, right}, current_code) do
    Map.merge(
      %{current_code => char},
      Map.merge(
        build_decode_table(left, current_code <> "."),
        build_decode_table(right, current_code <> "-")
      )
    )
  end

  def decode(encoded_text) do
    table = decode_table()

    encoded_words = String.split(encoded_text, "  ")

    decoded_words =
      Enum.map(encoded_words, fn encoded_word ->
        encoded_chars = String.split(encoded_word, " ")
        decoded_chars = Enum.map(encoded_chars, &Map.get(table, &1, ""))
        decoded_chars
        |> Enum.map(&<<&1::utf8>>)
        |> Enum.join("")
      end)

    Enum.join(decoded_words, " ")
  end

  defp decode_morse([], _table, _current_code, acc), do: Enum.join(acc)

defp decode_morse([char | rest], table, current_code, acc) do
  case char do
    ' ' ->
      decode_morse(rest, table, "", acc)

    _ ->
      case Map.get(table, current_code <> <<char::utf8>>) do
        nil ->
          decode_morse(rest, table, current_code <> <<char::utf8>>, acc)

        code when is_integer(code) ->
          acc = acc ++ [<<code::utf8>>]
          decode_morse(rest, table, "", acc)

        _ ->
          decode_morse(rest, table, current_code <> <<char::utf8>>, acc)
      end
  end
end
end
