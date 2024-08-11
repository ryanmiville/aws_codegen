import decode.{type Decoder}

pub type ShapeId {
  ShapeId(String)
}

pub fn decoder() -> Decoder(ShapeId) {
  decode.map(decode.string, ShapeId)
}
