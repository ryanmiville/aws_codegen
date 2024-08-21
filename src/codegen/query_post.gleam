import codegen/module.{type Module, Post}
import gleam/list
import gleam/string
import internal/stringutils
import smithy/shape
import smithy/shape_id.{type ShapeId, ShapeId}

pub const imports = "
import aws/client.{type Client}
import aws/config.{type Config}
import aws/internal/endpoint
import gleam/bit_array
import gleam/dynamic.{type Dynamic}
import gleam/http.{type Header}
import gleam/http/response.{type Response}
import gleam/int
import gleam/option.{type Option, Some}

"

const fn_template = "
pub fn FUNCTION_NAME(
  client: Client,
  body: BitArray,
  headers: List(Header),
  query: Option(String),
) -> Result(Response(BitArray), Dynamic) {
  let content_length = bit_array.byte_size(body) |> int.to_string
  let headers = [
    #(\"content-type\", content_type),
    #(\"content-length\", content_length),
    ..headers
  ]
  client.send(client, http.Post, \"\", headers, query, Some(body))
}

"

pub fn generate_functions(module: Module) -> String {
  let assert Post(_, _, _, _, _, operations) = module
  operations
  |> list.map(generate_function)
  |> string.concat
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
