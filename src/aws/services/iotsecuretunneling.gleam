import aws/aws
import aws/client.{type Client}
import aws/config.{type Config}
import aws/internal/endpoint

const content_type = "application/x-amz-json-1.1"

const endpoint_prefix = "api.tunneling.iot"

const service_id = "IoTSecuredTunneling"

const signing_name = "IoTSecuredTunneling"

pub fn new(config: Config) -> Client {
  let endpoint = endpoint.resolve(config, endpoint_prefix)
  client.Client(config, service_id, signing_name, endpoint)
}

pub fn close_tunnel(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "CloseTunnel", request_body, content_type)
}

pub fn describe_tunnel(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DescribeTunnel", request_body, content_type)
}

pub fn list_tags_for_resource(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListTagsForResource", request_body, content_type)
}

pub fn list_tunnels(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListTunnels", request_body, content_type)
}

pub fn open_tunnel(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "OpenTunnel", request_body, content_type)
}

pub fn rotate_tunnel_access_token(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "RotateTunnelAccessToken",
    request_body,
    content_type,
  )
}

pub fn tag_resource(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "TagResource", request_body, content_type)
}

pub fn untag_resource(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "UntagResource", request_body, content_type)
}
