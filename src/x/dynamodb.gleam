import gleam/http
import gleam/http/request
import gleam/httpc
import x/client
import x/dynamodb/decode
import x/dynamodb/encode
import x/dynamodb/types
import x/time

pub type Client {
  Client(
    access_key_id: String,
    secret_access_key: String,
    region: String,
    service: String,
  )
}

pub fn new(
  access_key_id: String,
  secret_access_key: String,
  region: String,
) -> Client {
  Client(access_key_id, secret_access_key, region, "dynamodb")
}

pub fn get_item(
  client: Client,
  input: types.GetItemInput,
) -> Result(types.GetItemOutput, types.Error) {
  let body =
    encode.get_item_input(input)
    |> encode.json_bits

  let assert Ok(request) =
    request.to("https://dynamodb.us-east-1.amazonaws.com/")
  let request =
    request.Request(
      ..request,
      headers: [
        #("host", "dynamodb.us-east-1.amazonaws.com"),
        #("X-Amz-Target", "DynamoDB_20120810.GetItem"),
        #("content-type", "application/x-amz-json-1.0"),
      ],
    )
    |> request.set_method(http.Post)
    |> request.set_body(body)

  let request =
    client.sign(
      request,
      time.utc_now(),
      client.access_key_id,
      client.secret_access_key,
      client.region,
      client.service,
    )

  let assert Ok(resp) = httpc.send_bits(request)

  case resp.status >= 200 && resp.status < 300 {
    True -> {
      let assert Ok(output) =
        decode.from_json(resp.body, decode.get_item_output())
      Ok(output)
    }

    _ -> {
      let assert Ok(err) = decode.from_json(resp.body, decode.error())
      Error(err)
    }
  }
}
