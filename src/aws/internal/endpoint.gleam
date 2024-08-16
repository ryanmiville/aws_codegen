import aws/config
import gleam/bool
import gleam/list
import gleam/option.{None, Some}
import gleam/string

pub fn resolve(config: config.Config, endpoint_prefix: String) -> String {
  case config.endpoint {
    Some(ep) -> ep
    None -> do_resolve(config, endpoint_prefix)
  }
}

fn do_resolve(config: config.Config, endpoint_prefix: String) -> String {
  use <- bool.guard(config.region == "local", "http://localhost:8000")
  string.concat([
    "https://",
    endpoint_prefix,
    ".",
    config.region,
    ".",
    "amazonaws.com",
  ])
}

pub fn supported(region: String) -> Bool {
  unsupported_region_prefixes
  |> list.any(fn(prefix) { string.starts_with(region, prefix) })
  |> bool.negate
}

pub const unsupported_region_prefixes = ["cn-", "us-gov", "us-iso", "eu-iso"]
