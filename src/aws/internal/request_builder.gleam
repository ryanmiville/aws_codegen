import aws/internal/endpoint.{type Endpoint}
import aws/internal/time
import gleam/bit_array
import gleam/crypto
import gleam/http.{type Header}
import gleam/http/request.{type Request, Request}
import gleam/int
import gleam/list
import gleam/option.{type Option}
import gleam/string

pub type RequestBuilder {
  RequestBuilder(
    access_key_id: String,
    secret_access_key: String,
    service_id: String,
    endpoint: Endpoint,
  )
}

fn sign(
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

fn sign_v4(builder: RequestBuilder, request: Request(BitArray)) {
  sign(
    request,
    time.utc_now(),
    builder.access_key_id,
    builder.secret_access_key,
    builder.endpoint.signing_region,
    builder.endpoint.signing_name,
  )
}

pub fn build(
  builder: RequestBuilder,
  method: http.Method,
  path: String,
  headers: List(Header),
  query: Option(String),
  body: Option(BitArray),
) -> Request(BitArray) {
  let assert Ok(request) = request.to(url(builder.endpoint) <> path)
  let headers = [#("host", builder.endpoint.hostname), ..headers]

  let body = option.unwrap(body, bit_array.from_string(""))
  let request =
    request.Request(..request, headers: headers, query: query)
    |> request.set_method(method)
    |> request.set_body(body)

  sign_v4(builder, request)
}

fn url(endpoint: Endpoint) -> String {
  endpoint.protocol <> "://" <> endpoint.hostname <> "/"
}
