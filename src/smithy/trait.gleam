import decode.{type Decoder}
import gleam/dict
import smithy/shape_id.{type ShapeId}

pub type Trait {
  String(String)
  Int(Int)
  Bool(Bool)
  List(List(Trait))
  Dict(dict.Dict(ShapeId, Trait))
}

pub fn decoder() -> Decoder(Trait) {
  let int = decode.int |> decode.map(Int)
  let string = decode.string |> decode.map(String)
  let bool = decode.bool |> decode.map(Bool)
  let list = decode.list(lazy(decoder)) |> decode.map(List)
  let dict =
    decode.dict(shape_id.decoder(), lazy(decoder))
    |> decode.map(Dict)
  decode.one_of([int, string, bool, list, dict])
}

fn lazy(f: fn() -> Decoder(t)) -> Decoder(t) {
  decode.dynamic |> decode.then(fn(_) { f() })
}
