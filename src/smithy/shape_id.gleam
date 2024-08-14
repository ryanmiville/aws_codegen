import decode.{type Decoder}

pub type ShapeId {
  ShapeId(String)
}

pub fn to_string(shape_id: ShapeId) -> String {
  let ShapeId(id) = shape_id
  id
}

pub fn decoder() -> Decoder(ShapeId) {
  decode.map(decode.string, ShapeId)
}
