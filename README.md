# Bencode-elxr

Elixir solution for implementing the encoding and decoding of the Bencode
format. This project was completed for academic purposes and while it adheres
to the BitTorrent Spec it has not been tested with live BitTorrent traffic.

* [BitTorrent Specification](http://wiki.theory.org/BitTorrentSpecification)
* [Bencode](http://en.wikipedia.org/wiki/Bencode)

## Install

Add this github repository to your project dependencies.

## Usage


```elixir
import Bencode
{ status, result } = Bencode.decode(...)
Bencode.encode(...)

```


### Bencode#encode(object)

`object` is either a `String`, `Number`, `Array`, or `Object`.


```elixir
iex> Bencode.encode "fox molder"
"10:fox molder"
```

### Bencode#decode(string)

Returns a tuple of status `{:ok, ____}`

```elixir
iex> Bencode.decode "i400e"
{ :ok, 400 }

iex> Bencode.decode "17:hello cheese cake"
{ :ok, "hello cheese cake" }

iex> Bencode.decode "lll2:hieee"
{ :ok, [[["hi"]]]}

```
