import dot_env as dot
import gleam/bit_array
import pprint
import x/aws
import x/dynamodb

pub fn main() {
  dot.load()

  let client = dynamodb.new(aws.default_credentials_provider())

  let body =
    "{
    \"TableName\": \"doorman-production-WaitlistTable\",
    \"Key\": { \"email\": { \"S\": \"ryanmiville@gmail.com\" } }
    }"
    |> bit_array.from_string

  let output = dynamodb.get_item(client, body)
  pprint.debug(output)
}
