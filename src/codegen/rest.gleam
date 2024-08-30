import codegen/module.{
  type Module, type Operation, type Protocol, Operation, Rest, RestJson1,
  RestXml,
}
import codegen/operation
import decode
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/regex.{type Match}
import gleam/result
import gleam/string
import internal/stringutils
import smithy/shape
import smithy/shape_id.{type ShapeId, ShapeId}

fn get_operation(operation_name: ShapeId, spec: String) {
  operation.get_operation(operation_name, spec)
}

pub const imports = "
import aws4_request.{type Signer}
import aws_request/internal/endpoint
import aws_request/internal/metadata.{Metadata}
import aws_request/internal/request_builder
import gleam/http.{type Header}
import gleam/http/request.{type Request}
import gleam/option.{type Option}
import gleam/string
"

const fn_template = "
pub fn FUNCTION_NAME(
  client: Client,
  PARAMS
  headers: List(Header),
  query: Option(String),
) -> Request(BitArray) {
  PATH
  CONTENT_TYPE
  request_builder.build(
    client.signer,
    client.endpoint,
    METHOD,
    path,
    headers,
    query,
    BODY_OPTION,
  )

}

"

pub fn generate_functions(module: Module) -> String {
  let assert Rest(_, _, _, _, _, operations) = module
  operations
  |> list.map(fn(op) { generate_function(op, module.protocol) })
  |> string.concat
}

fn generate_function(operation: Operation, protocol: Protocol) -> String {
  let fn_name = stringutils.pascal_to_snake(operation.id)
  let has_body = option.is_some(operation.payload_type)
  let params = fn_params(operation.parameters, has_body)
  let content_type = content_type_header(operation.payload_type, protocol)
  let method = method(operation.method)
  let body_option = case has_body {
    True -> "option.Some(body)"
    False -> "option.None"
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

fn content_type_header(payload_type: Option(String), protocol: Protocol) {
  let content_type = case payload_type, protocol {
    Some("blob"), _ -> "application/octet-stream"
    Some("string"), _ -> "text/plain"
    Some("structure"), RestXml -> "application/xml"
    Some("structure"), RestJson1 -> "application/json"
    Some("union"), RestXml -> "application/xml"
    Some("union"), RestJson1 -> "application/json"
    Some("document"), RestJson1 -> "application/json"
    None, RestXml -> "application/xml"
    None, RestJson1 -> "application/json"
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

pub fn operations(operations: List(shape.Reference), spec: String) {
  list.map(operations, fn(op) { get_operation(op.target, spec) })
  |> result.all
  |> result.map_error(string.inspect)
}

pub fn operation(operation_name: String) {
  decode.into({
    use method <- decode.parameter
    use uri <- decode.parameter
    use code <- decode.parameter
    use input <- decode.parameter
    Operation("", method, uri, code, input, None, [], "")
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
    decode.optional(decode.int),
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
  case stringutils.pascal_to_snake(sub) {
    "type" -> "type_"
    s -> s
  }
}

fn replace(match: Match) -> String {
  let sn = snake(match)
  "\", " <> sn <> ", \""
}
