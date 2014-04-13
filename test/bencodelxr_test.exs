defmodule BencodeTest do
  use ExUnit.Case, async: true
  doctest Bencode

  #
  # Encoding
  #

  test "encodes a string as <length of String>:<String>" do
    assert "13:Hello encoder" = Bencode.encode "Hello encoder"
  end

  test "encodes int as i<int>e" do
    assert "i13e" = Bencode.encode 13
  end

  test "encodes negative intergers" do
    assert "i-13e" = Bencode.encode -13
  end

  test "encodes a list as l<list items>e" do
    assert "le" = Bencode.encode []
  end

  test "encodes a list" do
    assert "li1ei2e6:stringe" = Bencode.encode [1,2, "string"]
  end

  test "encodes a list with lists" do
    assert "li1ei2e6:stringl4:listee" = Bencode.encode [1,2, "string", ["list"]]
  end

  test "encodes a dictionary with sorted keys" do
    hashie = HashDict.new
    hashie = HashDict.put(hashie, "hello", "world")
    hashie = HashDict.put(hashie, "brett", "encode")
    assert "d6:encode5:brett5:world5:helloe" = Bencode.encode hashie
  end

  #
  # Decoding
  #

  test "decodes an int" do
    assert { :ok, 13 } = Bencode.decode "i13e"
  end

  test "decodes negative ints" do
    assert { :ok, -13 } = Bencode.decode "i-13e"
  end

  test "decodes a string" do
    assert { :ok, "helloworld" } = Bencode.decode "10:helloworld"
  end

  test "decodes a string with a colon" do
    assert { :ok, "127.0.0.1:4000" } = Bencode.decode "14:127.0.0.1:4000"
  end

  test "decodes a list" do
    assert { :ok, ["string", 1] } = Bencode.decode "l6:stringi1ee"
  end

  test "decodes nested lists" do
    assert { :ok, [[["banana"]]] } = Bencode.decode "lll6:bananaeee"
  end

  test "decodes empty list" do
    assert { :ok, [[]] } = Bencode.decode "llee"
  end

  test "decodes a dictionary" do
    hashie = HashDict.new
    hashie = HashDict.put(hashie, "hello", "world")
    assert { :ok, hashie } = Bencode.decode "d5:hello5:worlde"
  end

end
