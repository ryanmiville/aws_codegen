import gleam/bool
import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option, Some}
import gleam/result
import gleam/string
import internal/stringutils
import smithy/shape
import smithy/shape_id.{type ShapeId, ShapeId}
import smithy/trait.{type Trait}

pub type Protocol {
  Json10
  Json11
  RestJson1
  RestXml
  Ec2QueryName
  AwsQueryError
}

pub type Module {
  Module(
    service_id: String,
    endpoint_prefix: String,
    signing_name: String,
    protocol: Protocol,
    operations: List(String),
  )
}

pub type Error {
  Error(id: ShapeId, message: String)
}

pub fn from(tuple: #(shape_id.ShapeId, shape.Shape)) -> Result(Module, Error) {
  let #(id, shape) = tuple
  let assert shape.Service(_, operations, _, _, traits) = shape
  let error = Error(id, _)
  from_service(id, operations, traits)
  |> result.map_error(error)
}

fn reference_string(ref: shape.Reference) -> String {
  let ShapeId(name) = ref.target
  strip_prefix(name)
}

fn strip_prefix(string: String) -> String {
  let assert Ok(#(_, string)) = string.split_once(string, "#")
  string
}

fn content_type(protocol: Protocol) -> String {
  case protocol {
    Json10 -> "application/x-amz-json-1.0"
    Json11 -> "application/x-amz-json-1.1"
    RestJson1 -> panic as "not implemented"
    RestXml -> panic as "not implemented"
    Ec2QueryName -> panic as "not implemented"
    AwsQueryError -> panic as "not implemented"
  }
}

const template = "
import aws/aws
import aws/client.{type Client}

const content_type = \"CONTENT_TYPE\"

const endpoint_prefix = \"ENDPOINT_PREFIX\"

const service_id = \"SERVICE_ID\"

const signing_name = \"SIGNING_NAME\"

pub fn new(config: aws.Config) -> Client {
  client.Client(config, endpoint_prefix, service_id, signing_name)
}

"

const fn_template = "
pub fn FUNCTION_NAME(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, \"OPERATION_ID\", request_body, content_type)
}

"

pub fn generate(module: Module) -> String {
  let functions =
    module.operations
    |> list.map(generate_function)
    |> string.concat

  generate_client(module) <> functions
}

fn generate_client(module: Module) -> String {
  template
  |> string.replace("CONTENT_TYPE", content_type(module.protocol))
  |> string.replace("ENDPOINT_PREFIX", module.endpoint_prefix)
  |> string.replace("SERVICE_ID", module.service_id)
  |> string.replace("SIGNING_NAME", module.signing_name)
}

fn generate_function(operation_id: String) -> String {
  let fn_name = stringutils.pascal_to_snake(operation_id)

  fn_template
  |> string.replace("FUNCTION_NAME", fn_name)
  |> string.replace("OPERATION_ID", operation_id)
}

fn get(d: Dict(ShapeId, b), key: String) -> Result(b, String) {
  dict.get(d, ShapeId(key))
  |> result.replace_error(key <> " not found")
}

fn from_service(
  shape_id: shape_id.ShapeId,
  operations: List(shape.Reference),
  traits: Dict(ShapeId, Option(Trait)),
) -> Result(Module, String) {
  let shape_id.ShapeId(service_id) = shape_id
  let service_id = strip_prefix(service_id)

  use auth <- result.try(get(traits, "aws.auth#sigv4"))
  let assert Some(trait.Dict(auth)) = auth

  use signing_name <- result.try(get(auth, "name"))
  let assert trait.String(signing_name) = signing_name

  use api <- result.try(get(traits, "aws.api#service"))
  let assert Some(trait.Dict(api)) = api

  use endpoint_prefix <- result.map(get(api, "endpointPrefix"))
  let assert trait.String(endpoint_prefix) = endpoint_prefix

  let protocol = {
    use <- bool.guard(
      dict.has_key(traits, ShapeId("aws.protocols#awsJson1_0")),
      Json10,
    )
    use <- bool.guard(
      dict.has_key(traits, ShapeId("aws.protocols#awsJson1_1")),
      Json11,
    )
    use <- bool.guard(
      dict.has_key(traits, ShapeId("aws.protocols#restJson1")),
      RestJson1,
    )
    use <- bool.guard(
      dict.has_key(traits, ShapeId("aws.protocols#restXml")),
      RestXml,
    )
    use <- bool.guard(
      dict.has_key(traits, ShapeId("aws.protocols#ec2QueryName")),
      Ec2QueryName,
    )
    AwsQueryError
  }

  let operations = list.map(operations, reference_string)
  Module(service_id, endpoint_prefix, signing_name, protocol, operations)
}
