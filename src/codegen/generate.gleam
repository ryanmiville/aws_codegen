import codegen/json_post
import codegen/module.{
  type Global, type Module, type Protocol, AwsQueryError, Ec2QueryName, Global,
  Json10, Json11, Post, Rest, RestJson1, RestXml,
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
    Json10 | Json11 -> {
      json_post.imports
      <> generate_client(module)
      <> json_post.generate_functions(module)
    }
    RestXml | RestJson1 -> {
      rest.imports <> generate_client(module) <> rest.generate_functions(module)
    }
    Ec2QueryName | AwsQueryError -> {
      query_post.imports
      <> generate_client(module)
      <> query_post.generate_functions(module)
    }
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

  let is_global =
    json.decode(endpoint_spec, decode.from(is_global(endpoint_prefix), _))
  let assert Ok(is_global) = is_global

  let global = case is_global {
    True -> {
      let global =
        json.decode(endpoint_spec, decode.from(global(endpoint_prefix), _))
      let assert Ok(global) = global
      Some(global)
    }
    False -> None
  }
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

fn is_global(service: String) {
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

fn global(service: String) {
  use cs <- decode.then(global_credential_scope(service))
  use hn <- decode.map(global_hostname(service))
  Global(cs, hn)
}

fn global_credential_scope(service: String) {
  decode.at(
    [
      "services",
      service,
      "endpoints",
      "aws-global",
      "credentialScope",
      "region",
    ],
    decode.string,
  )
}

fn global_hostname(service: String) {
  decode.at(
    ["services", service, "endpoints", "aws-global", "hostname"],
    decode.string,
  )
}

const template = "
CONTENT_TYPE

const metadata = Metadata(
  endpoint_prefix: \"ENDPOINT_PREFIX\",
  service_id: \"SERVICE_ID\",
  signing_name: \"SIGNING_NAME\",
  global: GLOBAL,
)

pub opaque type Client {
  Client(builder: RequestBuilder)
}

pub fn new(config: Config) -> Client {
  let endpoint = resolve.endpoint(config, metadata)
  RequestBuilder(
    config.access_key_id,
    config.secret_access_key,
    metadata.service_id,
    endpoint,
  )
  |> Client
}

"

fn generate_client(module: Module) -> String {
  template
  |> string.replace("CONTENT_TYPE", generate_content_type(module.protocol))
  |> string.replace("ENDPOINT_PREFIX", module.endpoint_prefix)
  |> string.replace("SERVICE_ID", module.service_id)
  |> string.replace("SIGNING_NAME", module.signing_name)
  |> string.replace("GLOBAL", generate_global(module.global))
}

fn generate_global(global: Option(Global)) -> String {
  case global {
    Some(Global(credential_scope, hostname)) ->
      "option.Some(metadata.Global(\""
      <> credential_scope
      <> "\", \""
      <> hostname
      <> "\"))"
    None -> "option.None"
  }
}

fn generate_content_type(protocol: Protocol) -> String {
  case protocol {
    module.Json10 -> "const content_type = \"application/x-amz-json-1.0\""
    module.Json11 -> "const content_type = \"application/x-amz-json-1.1\""
    module.RestJson1 | module.RestXml -> ""
    module.AwsQueryError | module.Ec2QueryName ->
      "const content_type = \"application/x-www-form-urlencoded\""
  }
}
