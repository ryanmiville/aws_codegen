import gleam/dict
import smithy/service
import smithy/shape
import smithy/shape_id

pub fn services(
  service: service.Service,
) -> List(#(shape_id.ShapeId, shape.Shape)) {
  dict.filter(service.shapes, fn(_, shape) {
    case shape {
      shape.Service(..) -> True
      _ -> False
    }
  })
  |> dict.to_list
}
