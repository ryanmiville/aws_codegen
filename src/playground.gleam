import aws/config
import aws/services/dynamodb
import aws/services/s3
import dot_env as dot
import gleam/bit_array
import gleam/option.{None}
import gleam/result
import pprint

pub fn main() {
  dot.load()

  let assert Ok(client) =
    config.new()
    |> config.with_region("us-east-1")
    |> config.build
    |> result.map(s3.new)

  // let body =
  //   "{
  //   \"TableName\": \"doorman-production-WaitlistTable\",
  //   \"Key\": { \"email\": { \"S\": \"ryanmiville@gmail.com\" } }
  //   }"
  //   |> bit_array.from_string

  // let output = dynamodb.get_item(client, body)
  // pprint.debug(output)

  let output =
    s3.get_object(
      client,
      "doorman-production-landingpageassets-rhtuhono",
      "_astro/client.5I5BMcNS.js",
      [],
      None,
    )

  pprint.debug(output)
}
