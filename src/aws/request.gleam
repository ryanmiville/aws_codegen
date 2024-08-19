// import gleam/crypto
// import gleam/dict
// import gleam/dynamic
// import gleam/http
// import gleam/http/response.{type Response}
// import gleam/list
// import gleam/option.{type Option}
// import gleam/result
// import gleam/string

// pub type Client {
//   Client(
//     access_key_id: String,
//     secret_access_key: String,
//     region: String,
//     endpoint: Option(String),
//     proto: String,
//     port: Int,
//     service: String,
//   )
// }

// pub type Metadata {
//   Metadata(
//     content_type: String,
//     protocol: String,
//     target_prefix: String,
//     api_version: String,
//     signing_name: String,
//     global: Bool,
//     hostname: Option(String),
//     endpoint_prefix: String,
//     credential_scope: Option(String),
//   )
// }

// pub type RequestResult {
//   Ok(body: String, response: Response)
//   Error(error: String)
// }

// pub fn request_post(
//   client: Client,
//   metadata: Metadata,
//   action: String,
//   input: dict.Dict(String, String),
//   options: dict.Dict(String, String),
// ) -> RequestResult {
//   let client = prepare_client(client, metadata)

//   let host = build_host(client, metadata, [])

//   let url = build_uri(client, host, "/")

//   let headers = [#("Host", host), #("Content-Type", metadata.content_type)]

//   let headers = case metadata.protocol {
//     "json" ->
//       list.append(headers, [
//         #("X-Amz-Target", metadata.target_prefix <> "." <> action),
//       ])
//     _ -> headers
//   }
//   let input = case metadata.protocol {
//     "query" | "ec2" ->
//       dict.insert(input, "Action", action)
//       |> dict.insert("Version", metadata.api_version)
//     _ -> input
//   }

//   let payload = encode(client, metadata.protocol, input)

//   let headers = case client.access_key_id, client.secret_access_key {
//     Some(access_key), Some(secret_key) ->
//       sign_v4(
//         client,
//         now(),
//         "POST",
//         url,
//         headers,
//         payload,
//         access_key,
//         secret_key,
//       )
//     _ -> headers
//   }

//   use response <- result.try(http.post(url, headers, payload))
//   case response.status {
//     200 -> {
//       let body = case response.body {
//         Some(body) -> decode(client, metadata.protocol, body)
//         None -> ""
//       }
//       Ok(body: body, response: response)
//     }
//     _ -> Error(error: "Unexpected response")
//   }
// }

// pub fn request_rest(
//   client: Client,
//   metadata: Metadata,
//   http_method: String,
//   path: String,
//   query: dict.Dict(String, String),
//   headers: List(#(String, String)),
//   input: dict.Dict(String, String),
//   options: dict.Dict(String, String),
//   success_status_code: Option(Int),
// ) -> RequestResult {
//   let client = prepare_client(client, metadata)

//   let host = build_host(client, metadata, headers)

//   let url = build_uri(client, host, path)
//   let url = add_query(url, query, client)

//   let send_body_as_binary =
//     dict.get(options, "sendBodyAsBinary")
//     |> result.unwrap(False)
//   let receive_body_as_binary =
//     dict.get(options, "receiveBodyAsBinary")
//     |> result.unwrap(False)

//   let default_content_type = case send_body_as_binary {
//     True -> "application/octet-stream"
//     False -> metadata.content_type
//   }

//   let static_additional_headers = [
//     #("Host", host),
//     #("Content-Type", default_content_type),
//   ]

//   let payload = case send_body_as_binary {
//     True -> dict.get(input, "Body") |> result.unwrap("")
//     False ->
//       case string.lowercase(http_method) {
//         "get" | "head" | "options" -> ""
//         _ -> encode(client, metadata.protocol, input)
//       }
//   }

//   let append_sha256_content_hash =
//     dict.get(options, "appendSha256ContentHash")
//     |> result.unwrap(False)

//   let static_additional_headers = case append_sha256_content_hash {
//     True -> {
//       let checksum =
//         crypto.hash(crypto.Sha256, payload)
//         |> crypto.base64_encode
//       list.append(static_additional_headers, [
//         #("X-Amz-CheckSum-SHA256", checksum),
//       ])
//     }
//     False -> Nil
//   }

//   let headers = add_headers(static_additional_headers, headers)

//   let headers =
//     sign_v4(
//       client,
//       now(),
//       http_method,
//       url,
//       headers,
//       payload,
//       client.access_key_id,
//       client.secret_access_key,
//     )

//   let response_header_parameters =
//     dict.get(options, "responseHeaderParameters")
//     |> result.unwrap([])

//   use response <- result.try(http.request(http_method, url, headers, payload))

//   case success_status_code {
//     Some(code) if response.status == code -> {
//       let body = case response.body {
//         Some(body) ->
//           case receive_body_as_binary {
//             True -> dict.from_list([#("Body", body)])
//             False -> decode(client, metadata.protocol, body)
//           }
//         None -> ""
//       }
//       let body =
//         merge_body_with_response_headers(
//           body,
//           response,
//           response_header_parameters,
//         )
//       Ok(body: body, response: response)
//     }
//     None if response.status >= 200 && response.status < 300 -> {
//       let body = case response.body {
//         Some(body) ->
//           case receive_body_as_binary {
//             True -> dict.from_list([#("Body", body)])
//             False -> decode(client, metadata.protocol, body)
//           }
//         None -> ""
//       }
//       let body =
//         merge_body_with_response_headers(
//           body,
//           response,
//           response_header_parameters,
//         )
//       Ok(body: body, response: response)
//     }
//     _ -> Error(error: "Unexpected response")
//   }
// }

// fn prepare_client(client: Client, metadata: Metadata) -> Client {
//   Client(..client, service: metadata.signing_name)
//   |> case metadata.global, client.region {
//     True, "local" -> client
//     True, _ -> Client(..client, region: metadata.credential_scope)
//     False, _ -> client
//   }
// }

// fn build_host(
//   client: Client,
//   metadata: Metadata,
//   headers: List(#(String, String)),
// ) -> String {
//   case client.region, client.endpoint {
//     "local", None -> "localhost"
//     _, Some(endpoint) -> endpoint
//     _, None -> {
//       let endpoint = resolve_endpoint_suffix(client.endpoint)
//       let region = option.unwrap(metadata.credential_scope, client.region)
//       build_final_endpoint(
//         [metadata.host_prefix <> metadata.endpoint_prefix, region, endpoint],
//         metadata,
//         headers,
//       )
//     }
//   }
// }

// fn resolve_endpoint_suffix(endpoint: Option(String)) -> String {
//   // case endpoint {
//   //   Some(e) if string.contains(e, "keepPrefixes") -> e
//   //   _ -> option.unwrap(endpoint, default_endpoint())
//   // }
//   option.unwrap(endpoint, default_endpoint())
// }

// fn build_final_endpoint(
//   parts: List(String),
//   metadata: Metadata,
//   headers: List(#(String, String)),
// ) -> String {
//   case metadata.endpoint_prefix {
//     "s3-control" -> {
//       let account_id =
//         list.find(headers, fn(h) { h.0 == "x-amz-account-id" })
//         |> result.map(fn(h) { h.1 })
//         |> result.unwrap("")
//       case account_id {
//         "" -> panic as "missing account_id"
//         id -> [id, ..parts]
//       }
//     }
//     _ -> parts
//   }
//   |> string.join(".")
//   |> string.replace("{AccountId}", account_id)
// }

// fn build_uri(client: Client, host: String, path: String) -> String {
//   client.proto <> "://" <> host <> ":" <> string.inspect(client.port) <> path
// }

// fn add_query(
//   uri: String,
//   query: dict.Dict(String, String),
//   client: Client,
// ) -> String {
//   case dict.size(query) {
//     0 -> uri
//     _ -> {
//       let query_string = encode(client, "query", query)
//       case string.contains(uri, "?") {
//         True -> uri <> "&" <> query_string
//         False -> uri <> "?" <> query_string
//       }
//     }
//   }
// }

// fn encode(
//   client: Client,
//   protocol: String,
//   payload: dict.Dict(String, String),
// ) -> String {
//   case protocol {
//     "ec2" | "query" -> encode_query(payload)
//     "rest-xml" -> encode_xml(payload)
//     "json" | "rest-json" -> encode_json(payload)
//     _ -> panic as "Unsupported protocol"
//   }
// }

// fn decode(client: Client, protocol: String, payload: String) -> dynamic.Dynamic {
//   case protocol {
//     "query" | "rest-xml" | "ec2" -> decode_xml(payload)
//     "json" | "rest-json" -> decode_json(payload)
//     _ -> panic as "Unsupported protocol"
//   }
// }

// fn merge_body_with_response_headers(
//   body: dynamic.Dynamic,
//   response: Response,
//   response_header_parameters: List(#(String, String)),
// ) -> dynamic.Dynamic {
//   list.fold(response_header_parameters, body, fn(acc, param) {
//     let #(header_name, key) = param
//     case dict.get(response.headers, header_name) {
//       Ok(value) -> dynamic.insert(acc, key, value)
//       Error(_) -> acc
//     }
//   })
// }

// fn build_params(
//   mapping: List(#(String, String)),
//   params: dict.Dict(String, String),
// ) -> #(dict.Dict(String, String), List(#(String, String))) {
//   list.fold(mapping, #(params, []), fn(acc, map_item) {
//     let #(params, headers) = acc
//     let #(param_name, header_name) = map_item
//     case dict.get(params, param_name) {
//       Ok(value) -> {
//         let new_params = dict.delete(params, param_name)
//         let new_headers = [#(header_name, value), ..headers]
//         #(new_params, new_headers)
//       }
//       Error(_) -> acc
//     }
//   })
// }

// fn add_headers(
//   additions: List(#(String, String)),
//   headers: List(#(String, String)),
// ) -> List(#(String, String)) {
//   list.fold(additions, headers, fn(acc, addition) {
//     case list.find(acc, fn(h) { h.0 == addition.0 }) {
//       Ok(_) -> acc
//       Error(_) -> [addition, ..acc]
//     }
//   })
// }
// // Note: The following functions are not implemented in this conversion
// // as they would require additional Gleam libraries or custom implementations:
// // - sign_v4
// // - now
// // - encode_query
// // - encode_xml
// // - encode_json
// // - decode_xml
// // - decode_json
// // - default_endpoint

// // These functions would need to be implemented separately or
// // by using appropriate Gleam libraries.
