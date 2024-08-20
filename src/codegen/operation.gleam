import codegen/module.{type Operation, Operation}

import decode
import gleam/dict.{type Dict}
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/regex.{type Match}
import gleam/result
import gleam/string
import internal/stringutils
import smithy/shape
import smithy/shape_id.{type ShapeId, ShapeId}

pub fn get_operation(
  operation_name: ShapeId,
  spec: String,
) -> Result(Operation, json.DecodeError) {
  let ShapeId(name) = operation_name
  let decoder = operation(name)
  use op <- result.try(json.decode(spec, decode.from(decoder, _)))
  let payload_type = operation_http_payload_type(op.input)
  use payload_type <- result.map(
    json.decode(spec, decode.from(payload_type, _)),
  )
  let id = strip_prefix(name)
  let params = op_params(op.uri)
  let path_code = build_uri(op.uri)
  Operation(
    ..op,
    id: id,
    parameters: params,
    path_code: path_code,
    payload_type: payload_type,
  )
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

fn strip_prefix(string: String) -> String {
  let assert Ok(#(_, string)) = string.split_once(string, "#")
  string
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

fn payload_id(members: Dict(String, shape.Member)) -> Option(String) {
  let members = dict.values(members)
  let payload = {
    use member <- list.find(members)
    dict.has_key(member.traits, shape_id.ShapeId("smithy.api#httpPayload"))
  }
  case payload {
    Ok(shape.Member(ShapeId(id), _)) -> Some(id)
    _ -> None
  }
}

fn payload_type(id: String) {
  decode.at(["shapes", id, "type"], decode.string)
}

fn operation_http_payload_type(input_id: String) {
  let struct = decode.at(["shapes", input_id], decode.optional(shape.decoder()))
  use struct <- decode.then(struct)
  let members = case struct {
    Some(shape.Structure(_, members)) -> members
    _ -> dict.new()
  }
  case payload_id(members) {
    Some(id) -> payload_type(id) |> decode.map(Some)
    None -> decode.into(None)
  }
}
