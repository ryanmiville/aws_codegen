// To get an item from an Amazon DynamoDB table, you can use the following HTTP URI format:

// ```
// POST / HTTP/1.1
// Host: dynamodb.<region>.amazonaws.com
// X-Amz-Target: DynamoDB_20120810.GetItem
// Content-Type: application/x-amz-json-1.0
// Authorization: AWS4-HMAC-SHA256 Credential=<your-access-key-id>/<date>/<aws-region>/dynamodb/aws4_request, SignedHeaders=content-type;host;x-amz-date;x-amz-target, Signature=<your-signature>
// x-amz-date: <timestamp>
// Content-Length: <payload-size>
// ```

// The request body should include the table name and the key of the item you want to retrieve. Here's an example of a request body in JSON:

// ```json
// {
//   "TableName": "your-table-name",
//   "Key": {
//     "your-key-attribute-name": {
//       "S": "your-key-attribute-value"
//     }
//   }
// }
// ```

// Replace the placeholders with the appropriate values:

// -  `<region>`: AWS region where your DynamoDB table is hosted
// -  `<your-access-key-id>`: Your AWS access key ID
// -  `<date>`: Date in `YYYYMMDD` format
// -  `<aws-region>`: The AWS region (as above)
// -  `<timestamp>`: The current timestamp in the required format
// -  `<payload-size>`: The size of the payload in bytes

// Here's a minimal example using the `curl` command:

// ```sh
// curl -X POST https://dynamodb.us-west-2.amazonaws.com/ \
// -H "X-Amz-Target: DynamoDB_20120810.GetItem" \
// -H "Content-Type: application/x-amz-json-1.0" \
// -H "Authorization: AWS4-HMAC-SHA256 <authorization-header>" \
// -H "x-amz-date: <timestamp>" \
// -d '{
//     "TableName": "your-table-name",
//     "Key": {
//         "your-key-attribute": {"S": "your-key-value"}
//     }
// }'
// ```

// Make sure to replace the placeholders with your actual values.

import gleam/bit_array
import gleam/http
import gleam/http/request.{type Request, Request}
import gleam/json

pub fn get_item_req() -> Request(BitArray) {
  let body =
    json.object([
      #("TableName", json.string("")),
      #("Key", json.object([#("", json.object([#("S", json.string(""))]))])),
    ])
    |> json.to_string
    |> bit_array.from_string

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

  request
  |> request.set_method(http.Post)
  |> request.set_body(body)
}
