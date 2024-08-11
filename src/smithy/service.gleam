import decode.{type Decoder}
import gleam/dict.{type Dict}
import smithy/shape.{type Shape}
import smithy/shape_id.{type ShapeId}

pub type Service {
  Service(smithy: String, shapes: Dict(ShapeId, Shape))
}

pub fn decoder() -> Decoder(Service) {
  decode.into({
    use smithy <- decode.parameter
    use shapes <- decode.parameter
    Service(smithy, shapes)
  })
  |> decode.field("smithy", decode.string)
  |> decode.field("shapes", decode.dict(shape_id.decoder(), shape.decoder()))
}
