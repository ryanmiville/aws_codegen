import aws/config.{type Config}
import aws/endpoint.{type Endpoint, Endpoint}
import aws/metadata.{type Metadata, Global}
import gleam/bool
import gleam/list
import gleam/option.{None, Some}
import gleam/string

pub fn endpoint(config: Config, metadata: Metadata) -> Endpoint {
  case config.endpoint {
    Some(ep) -> {
      let #(protocol, hostname) = split_scheme(ep)
      Endpoint(hostname, protocol, config.region, metadata.signing_name)
    }
    None -> do_resolve_new(config, metadata)
  }
}

fn split_scheme(uri: String) {
  case uri {
    "https://" <> host -> #("https", host)
    "http://" <> host -> #("http", host)
    other -> #("https", other)
  }
}

fn do_resolve_new(config: Config, metadata: Metadata) -> Endpoint {
  case config.region, metadata.global {
    "local", _ ->
      Endpoint("localhost:8000", "http", "us-east-1", metadata.signing_name)
    _, Some(Global(region, hostname)) ->
      Endpoint(hostname, "https", region, metadata.signing_name)
    region, None ->
      Endpoint(
        default(config, metadata),
        "https",
        region,
        metadata.signing_name,
      )
  }
}

fn default(config: Config, metadata: Metadata) {
  string.concat([
    metadata.endpoint_prefix,
    ".",
    config.region,
    ".",
    "amazonaws.com",
  ])
}

pub fn resolve(config: Config, endpoint_prefix: String) -> String {
  case config.endpoint {
    Some(ep) -> ep
    None -> do_resolve(config, endpoint_prefix, False)
  }
}

pub fn resolve_global(config: Config, endpoint_prefix: String) -> String {
  case config.endpoint {
    Some(ep) -> ep
    None -> do_resolve(config, endpoint_prefix, True)
  }
}

fn do_resolve(config: Config, endpoint_prefix: String, global: Bool) -> String {
  use <- bool.guard(config.region == "local", "http://localhost:8000")
  case global {
    False ->
      string.concat([
        "https://",
        endpoint_prefix,
        ".",
        config.region,
        ".",
        "amazonaws.com",
      ])
    True -> string.concat(["https://", endpoint_prefix, ".", "amazonaws.com"])
  }
}

pub fn supported(region: String) -> Bool {
  unsupported_region_prefixes
  |> list.any(fn(prefix) { string.starts_with(region, prefix) })
  |> bool.negate
}

pub const unsupported_region_prefixes = ["cn-", "us-gov", "us-iso", "eu-iso"]
