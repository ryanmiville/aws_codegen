import gleam/bit_array
import gleam/bool
import gleam/crypto
import gleam/http
import gleam/http/request.{type Request, Request}
import gleam/httpc
import gleam/int
import gleam/list
import gleam/option
import gleam/string
import x/aws
import x/time

pub type Client {
  Client(
    access_key_id: String,
    secret_access_key: String,
    region: String,
    content_type: String,
    endpoint_prefix: String,
    service_id: String,
    signing_name: String,
  )
}

pub fn sign(
  request request: Request(BitArray),
  time time: time.Time,
  access_key_id access_key_id: String,
  secret_access_key secret_access_key: String,
  region region: String,
  service service: String,
) -> Request(BitArray) {
  let payload_hash =
    string.lowercase(
      bit_array.base16_encode(crypto.hash(crypto.Sha256, request.body)),
    )

  let #(time.Date(year, month, day), time.DayTime(hour, minute, second, _)) =
    time.to_parts(time)
  let date =
    string.concat([
      string.pad_left(int.to_string(year), 4, "0"),
      string.pad_left(int.to_string(month), 2, "0"),
      string.pad_left(int.to_string(day), 2, "0"),
    ])
  let date_time =
    string.concat([
      date,
      "T",
      string.pad_left(int.to_string(hour), 2, "0"),
      string.pad_left(int.to_string(minute), 2, "0"),
      string.pad_left(int.to_string(second), 2, "0"),
      "Z",
    ])

  let method = string.uppercase(http.method_to_string(request.method))
  let headers =
    request.headers
    |> list.prepend(#("x-amz-date", date_time))
    |> list.prepend(#("x-amz-content-sha256", payload_hash))
    |> list.map(fn(header) { #(string.lowercase(header.0), header.1) })
    |> list.sort(fn(a, b) { string.compare(a.0, b.0) })

  let header_names =
    headers
    |> list.map(fn(h) { h.0 })
    |> string.join(";")

  let canonical_request =
    string.concat([
      method,
      "\n",
      request.path,
      "\n",
      option.unwrap(request.query, ""),
      "\n",
      {
        headers
        |> list.map(fn(h) { h.0 <> ":" <> h.1 })
        |> string.join("\n")
      },
      "\n",
      "\n",
      header_names,
      "\n",
      payload_hash,
    ])

  let scope = string.concat([date, "/", region, "/", service, "/aws4_request"])

  let to_sign =
    string.concat([
      "AWS4-HMAC-SHA256",
      "\n",
      date_time,
      "\n",
      scope,
      "\n",
      string.lowercase(
        bit_array.base16_encode(
          crypto.hash(crypto.Sha256, <<canonical_request:utf8>>),
        ),
      ),
    ])

  let key =
    <<"AWS4":utf8, secret_access_key:utf8>>
    |> crypto.hmac(<<date:utf8>>, crypto.Sha256, _)
    |> crypto.hmac(<<region:utf8>>, crypto.Sha256, _)
    |> crypto.hmac(<<service:utf8>>, crypto.Sha256, _)
    |> crypto.hmac(<<"aws4_request":utf8>>, crypto.Sha256, _)

  let signature =
    <<to_sign:utf8>>
    |> crypto.hmac(crypto.Sha256, key)
    |> bit_array.base16_encode
    |> string.lowercase

  let authorization =
    string.concat([
      "AWS4-HMAC-SHA256 Credential=",
      access_key_id,
      "/",
      scope,
      ",SignedHeaders=" <> header_names <> ",Signature=",
      signature,
    ])

  let headers = [#("authorization", authorization), ..headers]

  Request(..request, headers: headers)
}

pub fn post_json(
  client: Client,
  operation_id: String,
  body: BitArray,
) -> Result(BitArray, aws.Error) {
  let host = client.endpoint_prefix <> "." <> client.region <> ".amazonaws.com"

  let target = client.service_id <> "." <> operation_id

  let assert Ok(request) = request.to("https://" <> host <> "/")

  let request =
    request.Request(
      ..request,
      headers: [
        #("host", host),
        #("X-Amz-Target", target),
        #("content-type", client.content_type),
      ],
    )
    |> request.set_method(http.Post)
    |> request.set_body(body)

  let request = sign_v4(client, request)

  let response = httpc.send_bits(request)

  case response {
    Ok(resp) -> {
      use <- bool.guard(resp.status == 200, Ok(resp.body))
      let assert Ok(body) = bit_array.to_string(resp.body)
      Error(aws.ServiceError(body))
    }
    Error(dyn) -> Error(aws.UnknownError(string.inspect(dyn)))
  }
}

fn sign_v4(client: Client, request: Request(BitArray)) {
  sign(
    request,
    time.utc_now(),
    client.access_key_id,
    client.secret_access_key,
    client.region,
    client.signing_name,
  )
}
