defmodule Bencode do

  @moduledoc "Elixir solution for implementing the encoding and decoding of
  the Bencode format."

  @doc """
    encodes strings into the bencode format
    iex> Bencode.encode "fox molder"
    "10:fox molder"

  """
  def encode(obj) when is_bitstring(obj) do
    "#{String.length(obj)}:#{obj}"
  end

  @doc """
    encodes a number into the bencode format
    iex> Bencode.encode 304
    "i304e"
  """
  def encode(obj) when is_number(obj) do
    "i#{obj}e"
  end

  @doc """
    encodes a list into the bencode format
    iex> Bencode.encode [1,2, "string"]
    "li1ei2e6:stringe"
  """
  def encode(obj) when is_list(obj) do
    "l#{Enum.map(obj, fn(x) -> encode(x) end)}e"
  end

  @doc """
    encodes a dictionary into the bencode format
    iex> h = HashDict.new
    iex> h = HashDict.put(h, "cheese", "cake")
    #HashDict<[{"cheese", "cake"}]>
  """
  def encode(obj) do
    "d#{obj.keys |> Enum.sort
    |> Enum.map(fn(k) -> encode(obj[k], k) end)}e"
  end

  @doc """
    Decodes all bencode objects into objects that can be consumed by
    Elixir.

    # Examples

    iex> Bencode.decode "i400e"
    { :ok, 400 }

    iex> Bencode.decode "17:hello cheese cake"
    { :ok, "hello cheese cake" }

    iex> Bencode.decode "lll2:hieee"
    { :ok, [[["hi"]]]}

  """
  def decode(obj) do
    try do
      { result, _ } = dec(obj)
      { :ok , result }
    catch
      _ -> {:error, "Cannot decode"}
    end
  end

  # Match on first char
  defp dec(<< ?l, tail :: binary >>), do: dec_list(tail)

  defp dec(<< ?i, tail :: binary >>), do: dec_int(tail)

  defp dec(<< ?d, tail :: binary >>), do: dec_dict(tail, HashDict.new)

  defp dec(obj) do
    length = Regex.run(~r/\d+/, obj) |> List.first |> to_int
    start = length |> to_string |> String.length |> + 1
    {
      String.slice(obj, start, length),
      String.slice(obj, (start + length)..-1)
    }
  end

  defp dec_list(<< ?e, tail ::binary >>, acc) do
     { acc, tail }
  end

  defp dec_list(obj, acc \\ []) do
    { result, tail } = dec(obj)
    dec_list tail, acc ++ [result]
  end

  defp dec_int(<< ?e , tail :: binary >>, acc) do
    { list_to_integer(Enum.reverse(acc)), tail }
  end

  defp dec_int(<< x :: integer, tail :: binary >>, acc \\ []) do
    dec_int(tail, [ x | acc ])
  end

  defp dec_dict(<< ?e, tail :: binary >>, acc) do
    { acc, tail }
  end

  defp dec_dict(obj, dictionary) do
    { key, tail } = dec obj
    { val, tail_ } = dec tail
    dec_dict tail_, HashDict.put(dictionary, key, val)
  end

  defp to_int(obj) do
    case :string.to_integer(to_char_list(obj)) do
      {:error, _ } -> false
      { result, _ } -> result
    end
  end

  defp encode(k,v) do
    "#{encode(k)}#{encode(v)}"
  end
end
