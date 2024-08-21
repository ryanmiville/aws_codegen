import codegen/json_post
import codegen/module.{
  type Module, AwsQueryError, Ec2QueryName, Json10, Json11, Post, Rest,
  RestJson1, RestXml,
}
import codegen/query_post
import codegen/rest
import decode
import gleam/bool
import gleam/dict.{type Dict}
import gleam/json
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import smithy/shape
import smithy/shape_id.{type ShapeId, ShapeId}
import smithy/trait.{type Trait}

pub fn module(
  tuple: #(shape_id.ShapeId, shape.Shape),
  spec: String,
  endpoint_spec: String,
) -> Result(Module, module.Error) {
  let #(id, shape) = tuple
  let assert shape.Service(_, operations, _, _, traits) = shape
  let error = module.Error(id, _)
  from_service(id, operations, traits, spec, endpoint_spec)
  |> result.map_error(error)
}

pub fn code(module: Module) -> String {
  case module.protocol {
    Json10 | Json11 -> json_post.generate(module)
    RestXml | RestJson1 -> rest.generate(module)
    Ec2QueryName | AwsQueryError -> query_post.generate(module)
  }
}

fn get(d: Dict(ShapeId, b), key: String) -> Result(b, String) {
  dict.get(d, ShapeId(key))
  |> result.replace_error(key <> " not found")
}

fn strip_prefix(string: String) -> String {
  let assert Ok(#(_, string)) = string.split_once(string, "#")
  string
}

fn from_service(
  shape_id: shape_id.ShapeId,
  operations: List(shape.Reference),
  traits: Dict(ShapeId, Option(Trait)),
  spec: String,
  endpoint_spec: String,
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

  let global =
    json.decode(endpoint_spec, decode.from(global(endpoint_prefix), _))
  let assert Ok(global) = global
  case protocol {
    RestXml | RestJson1 -> {
      let assert Ok(ops) = rest.operations(operations, spec)
      Ok(Rest(service_id, endpoint_prefix, signing_name, protocol, global, ops))
    }
    Json10 | Json11 ->
      Ok(Post(
        service_id,
        endpoint_prefix,
        signing_name,
        protocol,
        global,
        json_post.operations(operations),
      ))
    Ec2QueryName | AwsQueryError ->
      Ok(Post(
        service_id,
        endpoint_prefix,
        signing_name,
        protocol,
        global,
        query_post.operations(operations),
      ))
  }
}

fn global(service: String) {
  let regionalized =
    decode.at(
      ["services", service, "isRegionalized"],
      decode.optional(decode.bool),
    )

  use r <- decode.map(regionalized)
  case r {
    Some(False) -> True
    Some(True) -> False
    None -> False
  }
}
