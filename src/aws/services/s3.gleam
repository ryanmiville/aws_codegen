import aws/client.{type Client}
import aws/config.{type Config}
import aws/internal/endpoint
import gleam/dynamic.{type Dynamic}
import gleam/http.{type Header}
import gleam/http/response.{type Response}
import gleam/option.{type Option, None, Some}
import gleam/string

const default_content_type = "text/xml"

const blob_content_type = "application/octet-stream"

const endpoint_prefix = "s3"

const service_id = "S3"

const signing_name = "s3"

pub fn new(config: Config) -> Client {
  let endpoint = endpoint.resolve(config, endpoint_prefix)
  client.Client(config, service_id, signing_name, endpoint)
}

pub fn get_object(
  client: Client,
  bucket: String,
  key: String,
  headers: List(Header),
  query: Option(String),
) -> Result(Response(BitArray), Dynamic) {
  let path = string.concat(["/", bucket, "/", key, "?x-id=GetObject"])
  let headers = [#("content-type", default_content_type), ..headers]
  client.send(client, http.Get, path, headers, query, None)
}

pub fn put_object(
  client: Client,
  bucket: String,
  key: String,
  body: BitArray,
  headers: List(Header),
  query: Option(String),
) -> Result(Response(BitArray), Dynamic) {
  let path = string.concat(["/", bucket, "/", key, "?x-id=PutObject"])
  let headers = [#("content-type", blob_content_type), ..headers]
  client.send(client, http.Put, path, headers, query, Some(body))
}
