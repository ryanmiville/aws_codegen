import decode
import gleam/bool
import gleam/dict.{type Dict}
import gleam/json
import gleam/list
import gleam/option.{type Option, Some}
import gleam/regex.{type Match}
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

pub type Operation {
  Operation(
    id: String,
    method: String,
    uri: String,
    code: Int,
    input: String,
    body: Bool,
    parameters: List(String),
    path_code: String,
  )
}

pub type Module {
  Module(
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

pub fn from(
  tuple: #(shape_id.ShapeId, shape.Shape),
  spec: String,
) -> Result(Module, Error) {
  let #(id, shape) = tuple
  let assert shape.Service(_, operations, _, _, traits) = shape
  let error = Error(id, _)
  from_service(id, operations, traits, spec)
  |> result.map_error(error)
}

fn get_operation(operation_name: ShapeId, spec: String) {
  let ShapeId(name) = operation_name
  let decoder = operation(name)
  use op <- result.map(json.decode(spec, decode.from(decoder, _)))
  let body =
    json.decode(spec, decode.from(body(op.input), _)) |> result.unwrap(False)
  let id = strip_prefix(name)
  let params = op_params(op.uri)
  let path_code = build_uri(op.uri)
  Operation(..op, id: id, parameters: params, path_code: path_code, body: body)
}

fn body(name: String) -> decode.Decoder(Bool) {
  decode.into({
    use body <- decode.parameter
    body
  })
  |> decode.subfield(
    ["shapes", name, "members", "Body", "target"],
    decode.string,
  )
  |> decode.map(fn(_) { True })
}

// fn reference_string(ref: shape.Reference) -> String {
//   let ShapeId(name) = ref.target
//   strip_prefix(name)
// }

fn strip_prefix(string: String) -> String {
  let assert Ok(#(_, string)) = string.split_once(string, "#")
  string
}

fn content_type(protocol: Protocol) -> String {
  case protocol {
    Json10 -> "application/x-amz-json-1.0"
    Json11 -> "application/x-amz-json-1.1"
    RestJson1 -> "application/json"
    RestXml -> "text/xml"
    Ec2QueryName -> panic as "not implemented"
    AwsQueryError -> panic as "not implemented"
  }
}

const template = "
import aws/client.{type Client}
import aws/config.{type Config}
import aws/internal/endpoint
import gleam/dynamic.{type Dynamic}
import gleam/http.{type Header}
import gleam/http/response.{type Response}
import gleam/option.{type Option, None, Some}
import gleam/string

const endpoint_prefix = \"ENDPOINT_PREFIX\"

const service_id = \"SERVICE_ID\"

const signing_name = \"SIGNING_NAME\"

pub fn new(config: Config) -> Client {
  let endpoint = endpoint.resolve(config, endpoint_prefix)
  client.Client(config, service_id, signing_name, endpoint)
}

"

const fn_template = "
pub fn FUNCTION_NAME(
  client: Client,
  PARAMS
  headers: List(Header),
  query: Option(String),
) -> Result(Response(BitArray), Dynamic) {
  PATH
  CONTENT_TYPE
  client.send(client, METHOD, path, headers, query, BODY_OPTION)
}

"

pub fn generate(module: Module) -> String {
  let functions =
    module.operations
    |> list.map(fn(op) { generate_function(op, module.protocol) })
    |> string.concat

  generate_client(module) <> functions
}

fn generate_client(module: Module) -> String {
  template
  |> string.replace("ENDPOINT_PREFIX", module.endpoint_prefix)
  |> string.replace("SERVICE_ID", module.service_id)
  |> string.replace("SIGNING_NAME", module.signing_name)
}

fn generate_function(operation: Operation, protocol: Protocol) -> String {
  let fn_name = stringutils.pascal_to_snake(operation.id)
  let params = fn_params(operation.parameters, operation.body)
  let content_type = content_type_header(operation.body, protocol)
  let method = method(operation.method)
  let body_option = case operation.body {
    True -> "Some(body)"
    False -> "None"
  }

  fn_template
  |> string.replace("FUNCTION_NAME", fn_name)
  |> string.replace("PARAMS", params)
  |> string.replace("PATH", operation.path_code)
  |> string.replace("CONTENT_TYPE", content_type)
  |> string.replace("METHOD", method)
  |> string.replace("BODY_OPTION", body_option)
}

fn method(method: String) {
  case method {
    "GET" -> "http.Get"
    "POST" -> "http.Post"
    "PUT" -> "http.Put"
    "DELETE" -> "http.Delete"
    "HEAD" -> "http.Head"
    "PATCH" -> "http.Patch"
    "OPTIONS" -> "http.Options"
    "TRACE" -> "http.Trace"
    "CONNECT" -> "http.Connect"
    _ -> panic as "not implemented"
  }
}

fn content_type_header(body: Bool, protocol: Protocol) {
  let content_type = case body, protocol {
    True, _ -> "application/octet-stream"
    False, RestJson1 -> "application/json"
    False, RestXml -> "text/xml"
    _, _ -> panic as "not implemented"
  }
  "
  let headers = [#(\"content-type\", \"" <> content_type <> "\"), ..headers]
  "
}

fn fn_params(params: List(String), body: Bool) -> String {
  let params =
    list.map(params, fn_param)
    |> string.concat

  case body {
    True -> params <> "body: BitArray,\n"
    False -> params
  }
}

fn fn_param(param: String) -> String {
  param <> ": String,\n"
}

fn get(d: Dict(ShapeId, b), key: String) -> Result(b, String) {
  dict.get(d, ShapeId(key))
  |> result.replace_error(key <> " not found")
}

fn from_service(
  shape_id: shape_id.ShapeId,
  operations: List(shape.Reference),
  traits: Dict(ShapeId, Option(Trait)),
  spec: String,
) -> Result(Module, String) {
  let shape_id.ShapeId(service_id) = shape_id
  let service_id = strip_prefix(service_id)

  use auth <- result.try(get(traits, "aws.auth#sigv4"))
  let assert Some(trait.Dict(auth)) = auth

  use signing_name <- result.try(get(auth, "name"))
  let assert trait.String(signing_name) = signing_name

  use api <- result.try(get(traits, "aws.api#service"))
  let assert Some(trait.Dict(api)) = api

  let endpoint_prefix = case get(api, "endpointPrefix") {
    Ok(trait.String(ep)) -> ep
    _ -> signing_name
  }

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

  let operations =
    list.map(operations, fn(op) { get_operation(op.target, spec) })
    |> result.all
    |> result.map_error(string.inspect)

  use operations <- result.map(operations)
  Module(service_id, endpoint_prefix, signing_name, protocol, operations)
}

pub fn operation(operation_name: String) {
  decode.into({
    use method <- decode.parameter
    use uri <- decode.parameter
    use code <- decode.parameter
    use input <- decode.parameter
    Operation("", method, uri, code, input, False, [], "")
  })
  |> decode.subfield(
    ["shapes", operation_name, "traits", "smithy.api#http", "method"],
    decode.string,
  )
  |> decode.subfield(
    ["shapes", operation_name, "traits", "smithy.api#http", "uri"],
    decode.string,
  )
  |> decode.subfield(
    ["shapes", operation_name, "traits", "smithy.api#http", "code"],
    decode.int,
  )
  |> decode.subfield(
    ["shapes", operation_name, "input", "target"],
    decode.string,
  )
}

const uri_param_pattern = "\\{(\\w+)\\+?\\}"

pub fn op_params(uri: String) {
  let assert Ok(re) = regex.from_string(uri_param_pattern)
  let matches = regex.scan(re, uri)
  list.map(matches, snake)
}

pub fn build_uri(uri: String) {
  let sub = stringutils.sub(uri, uri_param_pattern, replace)

  "
  let path = string.concat([\"" <> sub <> "\"])
  "
}

fn snake(match: Match) -> String {
  let assert [Some(sub)] = match.submatches
  stringutils.pascal_to_snake(sub)
}

fn replace(match: Match) -> String {
  let sn = snake(match)
  "\", " <> sn <> ", \""
}
