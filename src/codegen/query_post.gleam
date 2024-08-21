import codegen/module.{type Global, type Module, Global, Post}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import internal/stringutils
import smithy/shape
import smithy/shape_id.{type ShapeId, ShapeId}

const template = "
import aws/client.{type Client}
import aws/config.{type Config}
import aws/internal/endpoint
import gleam/dynamic.{type Dynamic}
import gleam/http.{type Header}
import gleam/http/response.{type Response}
import gleam/option.{type Option, Some}

const content_type = \"application/x-www-form-urlencoded\"

const endpoint_prefix = \"ENDPOINT_PREFIX\"

const service_id = \"SERVICE_ID\"

const signing_name = \"SIGNING_NAME\"

pub fn new(config: Config) -> Client {
  CONFIG
  let endpoint = endpoint.RESOLVE_FN(config, endpoint_prefix)
  client.Client(config, service_id, signing_name, endpoint)
}

"

const fn_template = "
pub fn FUNCTION_NAME(
  client: Client,
  body: BitArray,
  headers: List(Header),
  query: Option(String),
) -> Result(Response(BitArray), Dynamic) {
  let headers = [#(\"content-type\", content_type), ..headers]
  client.send(client, http.Post, \"\", headers, query, Some(body))
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
  |> string.replace("ENDPOINT_PREFIX", module.endpoint_prefix)
  |> string.replace("SERVICE_ID", module.service_id)
  |> string.replace("SIGNING_NAME", module.signing_name)
  |> string.replace("CONFIG", generate_config(module.global))
  |> string.replace("RESOLVE_FN", generate_resolve_fn(module.global))
}

fn generate_resolve_fn(global: Option(Global)) -> String {
  case global {
    Some(_) -> "resolve_global"
    None -> "resolve"
  }
}

fn generate_config(global: Option(Global)) -> String {
  case global {
    Some(Global(credential_scope, hostname)) ->
      "let config = config.Config(..config, region: \""
      <> credential_scope
      <> "\", endpoint: Some(\"https://"
      <> hostname
      <> "\"))"
    None -> ""
  }
}

fn generate_function(operation_id: String) -> String {
  let fn_name = stringutils.pascal_to_snake(operation_id)

  fn_template
  |> string.replace("FUNCTION_NAME", fn_name)
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
