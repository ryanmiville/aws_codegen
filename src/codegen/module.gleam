import gleam/option.{type Option}
import smithy/shape_id.{type ShapeId}

pub type Protocol {
  Json10
  Json11
  RestJson1
  RestXml
  Ec2QueryName
  AwsQueryError
}

pub type Operation {
  Operation(
    id: String,
    method: String,
    uri: String,
    code: Option(Int),
    input: String,
    payload_type: Option(String),
    parameters: List(String),
    path_code: String,
  )
}

pub type Module {
  Post(
    service_id: String,
    endpoint_prefix: String,
    signing_name: String,
    protocol: Protocol,
    operations: List(String),
  )
  Rest(
    service_id: String,
    endpoint_prefix: String,
    signing_name: String,
    protocol: Protocol,
    operations: List(Operation),
  )
}

pub type Error {
  Error(id: ShapeId, message: String)
}
