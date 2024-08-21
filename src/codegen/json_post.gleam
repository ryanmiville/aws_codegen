import codegen/module.{type Module, type Protocol, Post}
import gleam/bool
import gleam/list
import gleam/string
import internal/stringutils
import smithy/shape
import smithy/shape_id.{type ShapeId, ShapeId}

fn content_type(protocol: Protocol) -> String {
  case protocol {
    module.Json10 -> "application/x-amz-json-1.0"
    module.Json11 -> "application/x-amz-json-1.1"
    module.RestJson1 -> panic as "not implemented"
    module.RestXml -> panic as "not implemented"
    module.Ec2QueryName -> panic as "not implemented"
    module.AwsQueryError -> panic as "not implemented"
  }
}

const template = "
import aws/aws
import aws/client.{type Client}
import aws/config.{type Config}
import aws/internal/endpoint

const content_type = \"CONTENT_TYPE\"

const endpoint_prefix = \"ENDPOINT_PREFIX\"

const service_id = \"SERVICE_ID\"

const signing_name = \"SIGNING_NAME\"

const global = GLOBAL

pub fn new(config: Config) -> Client {
  let endpoint = endpoint.resolve(config, endpoint_prefix, global)
  client.Client(config, service_id, signing_name, endpoint)
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
  let assert Post(_, _, _, _, _, operations) = module
  let functions =
    operations
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
  |> string.replace("GLOBAL", bool.to_string(module.global))
}

fn generate_function(operation_id: String) -> String {
  let fn_name = stringutils.pascal_to_snake(operation_id)

  fn_template
  |> string.replace("FUNCTION_NAME", fn_name)
  |> string.replace("OPERATION_ID", operation_id)
}

pub fn operations(operations: List(shape.Reference)) -> List(String) {
  list.map(operations, reference_string)
}

fn reference_string(ref: shape.Reference) -> String {
  let ShapeId(name) = ref.target
  strip_prefix(name)
}

fn strip_prefix(string: String) -> String {
  let assert Ok(#(_, string)) = string.split_once(string, "#")
  string
}
