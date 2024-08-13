import x/aws
import x/client.{type Client}

pub fn new(config: aws.Config) -> Client {
  client.Client(
    config.access_key_id,
    config.secret_access_key,
    config.region,
    "application/x-amz-json-1.0",
    "dynamodb",
    "DynamoDB_20120810",
    "dynamodb",
  )
}

pub fn get_item(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetItem", request_body)
}
