import aws/aws
import aws/client.{type Client}
import aws/config.{type Config}
import aws/internal/endpoint

const content_type = "application/x-amz-json-1.0"

const endpoint_prefix = "healthlake"

const service_id = "HealthLake"

const signing_name = "healthlake"

pub fn new(config: Config) -> Client {
  let endpoint = endpoint.resolve(config, endpoint_prefix)
  client.Client(config, service_id, signing_name, endpoint)
}

pub fn create_f_h_i_r_datastore(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "CreateFHIRDatastore", request_body, content_type)
}

pub fn delete_f_h_i_r_datastore(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DeleteFHIRDatastore", request_body, content_type)
}

pub fn describe_f_h_i_r_datastore(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DescribeFHIRDatastore", request_body, content_type)
}

pub fn describe_f_h_i_r_export_job(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DescribeFHIRExportJob", request_body, content_type)
}

pub fn describe_f_h_i_r_import_job(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DescribeFHIRImportJob", request_body, content_type)
}

pub fn list_f_h_i_r_datastores(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListFHIRDatastores", request_body, content_type)
}

pub fn list_f_h_i_r_export_jobs(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListFHIRExportJobs", request_body, content_type)
}

pub fn list_f_h_i_r_import_jobs(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListFHIRImportJobs", request_body, content_type)
}

pub fn list_tags_for_resource(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListTagsForResource", request_body, content_type)
}

pub fn start_f_h_i_r_export_job(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "StartFHIRExportJob", request_body, content_type)
}

pub fn start_f_h_i_r_import_job(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "StartFHIRImportJob", request_body, content_type)
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
