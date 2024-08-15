import aws/client.{type Client}
import aws/config.{type Config}
import aws/internal/endpoint
import decode
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleeunit/should

import internal/fileio

pub fn test_endpoints(
  filepath: String,
  shape_id: String,
  constructor: fn(Config) -> Client,
) {
  let content = fileio.read_file(filepath)
  let assert Ok(test_cases) =
    json.decode(content, decode.from(decoder(shape_id), _))
  let test_cases =
    list.filter(test_cases, fn(tc) {
      case tc.expect, tc.params {
        Endpoint(_), Some(Params(Some(region), ..)) ->
          endpoint.supported(region)
        _, _ -> False
      }
    })

  use test_case <- list.each(test_cases)
  let assert Some(Params(Some(region), use_fips, use_dualstack, endpoint)) =
    test_case.params

  let config =
    config.Config(
      access_key_id: "",
      secret_access_key: "",
      region:,
      session_token: None,
      endpoint:,
      use_fips:,
      use_dualstack:,
    )

  let client = constructor(config)

  case test_case.expect {
    Endpoint(url) -> client.endpoint |> should.equal(url)
    Error(_) -> Nil
  }
}

type TestCase {
  TestCase(documentation: String, expect: Expect, params: Option(Params))
}

type Expect {
  Endpoint(url: String)
  Error(error: String)
}

type Params {
  Params(
    region: Option(String),
    use_fips: Bool,
    use_dualstack: Bool,
    endpoint: Option(String),
  )
}

fn decoder(shape_id: String) {
  decode.at(
    ["shapes", shape_id, "traits", "smithy.rules#endpointTests", "testCases"],
    decode.list(test_case()),
  )
}

fn test_case() {
  decode.into({
    use documentation <- decode.parameter
    use expect <- decode.parameter
    use params <- decode.parameter
    TestCase(documentation, expect, params)
  })
  |> decode.field("documentation", decode.string)
  |> decode.field("expect", expect())
  |> decode.field("params", decode.optional(params()))
}

fn expect() -> decode.Decoder(Expect) {
  let endpoint =
    decode.into(Endpoint)
    |> decode.subfield(["endpoint", "url"], decode.string)

  let error =
    decode.into(Error)
    |> decode.field("error", decode.string)

  decode.one_of([endpoint, error])
}

fn params() -> decode.Decoder(Params) {
  decode.into({
    use region <- decode.parameter
    use use_fips <- decode.parameter
    use use_dualstack <- decode.parameter
    use endpoint <- decode.parameter
    Params(region, use_fips, use_dualstack, endpoint)
  })
  |> decode.field("Region", decode.optional(decode.string))
  |> decode.field("UseFIPS", decode.bool)
  |> decode.field("UseDualStack", decode.bool)
  |> decode.field("Endpoint", decode.optional(decode.string))
}
