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
    prefix(endpoint_prefix, config.use_fips),
    ".",
    config.region,
    ".",
    partition_dns(config.use_dualstack),
  ])
}

fn prefix(endpoint_prefix: String, use_fips: Bool) {
  case use_fips {
    True -> endpoint_prefix <> "-fips"
    False -> endpoint_prefix
  }
}

fn partition_dns(use_dualstack: Bool) -> String {
  case use_dualstack {
    False -> "amazonaws.com"
    True -> "api.aws"
  }
}

pub fn supported(region: String) -> Bool {
  unsupported_region_prefixes
  |> list.any(fn(prefix) { string.starts_with(region, prefix) })
  |> bool.negate
}

pub const unsupported_region_prefixes = ["cn-", "us-gov", "us-iso", "eu-iso"]
