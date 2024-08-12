import decode.{type Decoder}
import gleam/bit_array
import gleam/dict.{type Dict}
import gleam/json.{type Json}
import gleam/list

pub fn lazy(f: fn() -> Decoder(t)) -> Decoder(t) {
  decode.dynamic |> decode.then(fn(_) { f() })
}

pub fn decode_base64() -> Decoder(BitArray) {
  use str <- decode.then(decode.string)
  case bit_array.base64_decode(str) {
    Ok(bits) -> decode.into(bits)
    _ -> decode.fail("failed to decode base64: " <> str)
  }
}

pub fn encode_base64(bytes: BitArray) -> Json {
  bit_array.base64_encode(bytes, False)
  |> json.string
}

pub fn encode_dict(input: Dict(String, v), f: fn(v) -> Json) -> Json {
  dict.to_list(input)
  |> list.map(fn(kv) {
    let #(k, v) = kv
    #(k, f(v))
  })
  |> json.object
}
