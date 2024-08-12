// import decode
import dot_env as dot
import dot_env/env
import gleam/dict
import gleam/option.{None}
import pprint
import x/dynamodb

pub fn main() {
  dot.load()

  let assert Ok(access_key_id) = env.get("AWS_ACCESS_KEY_ID")
  let assert Ok(secret_access_key) = env.get("AWS_SECRET_ACCESS_KEY")
  let region = "us-east-1"

  let client = dynamodb.new(access_key_id, secret_access_key, region)

  let key = dict.from_list([#("email", dynamodb.S("ryanmiville@gmail.com"))])

  let input =
    dynamodb.GetItemInput(
      table_name: "emails",
      key: key,
      attributes_to_get: None,
      consistent_read: None,
      expression_attribute_names: None,
      projection_expression: None,
      return_consumed_capacity: None,
    )

  // dynamodb.get_item_input_encoder(input)
  // |> json.to_string
  // |> io.println
  let output = dynamodb.get_item(client, input)
  pprint.debug(output)
}
