import codegen/module.{type Module, Post}
import gleam/list
import gleam/string
import internal/stringutils
import smithy/shape
import smithy/shape_id.{type ShapeId, ShapeId}

pub const imports = "
import aws/config.{type Config}
import aws/internal/resolve
import aws/metadata.{Metadata}
import aws/request_builder.{type RequestBuilder, RequestBuilder}
import gleam/http
import gleam/http/request.{type Request}
import gleam/option.{None, Some}
"

const fn_template = "
pub fn FUNCTION_NAME(
  client: Client,
  request_body: BitArray,
) -> Request(BitArray) {
  let target = client.builder.service_id <> \".OPERATION_ID\"
  let headers = [#(\"X-Amz-Target\", target), #(\"content-type\", content_type)]
  request_builder.build(client.builder, http.Post, \"\", headers, None, Some(request_body))
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
