// import decode
import dot_env as dot
import dot_env/env
import gleam/httpc
import pprint
import x/client
import x/dynamodb
import x/time

// import gleam/json
// import simplifile
// import smithy/service

pub fn main() {
  dot.load()

  let assert Ok(access_key_id) = env.get("AWS_ACCESS_KEY_ID")
  let assert Ok(secret_access_key) = env.get("AWS_SECRET_ACCESS_KEY")

  let region = "us-east-1"
  let service = "dynamodb"

  let request = dynamodb.get_item_req()

  let signed_request =
    client.sign(
      request,
      time.utc_now(),
      access_key_id,
      secret_access_key,
      region,
      service,
    )

  // Now send the signed request with a HTTP client
  httpc.send_bits(signed_request)
  |> pprint.debug
  // let assert Ok(example) = simplifile.read("./aws-models/s3.json")
  // let decoder = service.decoder()
  // let _ = json.decode(example, decode.from(decoder, _))

  // io.println("hello")
}
