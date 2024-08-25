// import aws/config
// import aws/x/service/dynamodb

// import aws/x/service/iam
// import aws/x/service/s3
// import dot_env as dot
// import gleam/bit_array
// import gleam/httpc
// import gleam/option.{None}
// import gleam/result
// import pprint

// pub fn main() {
//   dot.load()

//   let assert Ok(s3_client) =
//     config.new()
//     |> config.with_region("us-east-1")
//     |> config.build
//     |> result.map(s3.new)

//   let output =
//     s3.get_object(
//       s3_client,
//       "doorman-production-landingpageassets-rhtuhono",
//       "_astro/client.5I5BMcNS.js",
//       [],
//       None,
//     )
//     |> httpc.send_bits

//   let _ = pprint.debug(output)

//   let assert Ok(iam_client) =
//     config.new()
//     |> config.with_region("us-east-1")
//     |> config.build
//     |> result.map(iam.new)

//   let body =
//     "Action=ListUsers&Version=2010-05-08"
//     |> bit_array.from_string

//   let output =
//     iam.list_users(iam_client, body, [], None)
//     |> httpc.send_bits

//   let _ = pprint.debug(output)

//   let assert Ok(dynamo_client) =
//     config.new()
//     |> config.with_region("us-east-1")
//     |> config.build
//     |> result.map(dynamodb.new)

//   let body =
//     "{
//     \"TableName\": \"doorman-production-WaitlistTable\",
//     \"Key\": { \"email\": { \"S\": \"ryanmiville@gmail.com\" } }
//     }"
//     |> bit_array.from_string

//   let output =
//     dynamodb.get_item(dynamo_client, body)
//     |> httpc.send_bits

//   let _ = pprint.debug(output)
// }
