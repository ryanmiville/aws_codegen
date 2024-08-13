import x/aws
import x/client.{type Client}

const content_type = "application/x-amz-json-1.0"

const endpoint_prefix = "dynamodb"

const service_id = "DynamoDB_20120810"

const signing_name = "dynamodb"

pub fn new(config: aws.Config) -> Client {
  client.Client(
    config.access_key_id,
    config.secret_access_key,
    config.region,
    endpoint_prefix,
    service_id,
    signing_name,
  )
}

pub fn batch_execute_statement(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "BatchExecuteStatement", request_body, content_type)
}

pub fn batch_get_item(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "BatchGetItem", request_body, content_type)
}

pub fn batch_write_item(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "BatchWriteItem", request_body, content_type)
}

pub fn create_backup(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "CreateBackup", request_body, content_type)
}

pub fn create_global_table(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "CreateGlobalTable", request_body, content_type)
}

pub fn create_table(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "CreateTable", request_body, content_type)
}

pub fn delete_backup(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DeleteBackup", request_body, content_type)
}

pub fn delete_item(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DeleteItem", request_body, content_type)
}

pub fn delete_resource_policy(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DeleteResourcePolicy", request_body, content_type)
}

pub fn delete_table(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DeleteTable", request_body, content_type)
}

pub fn describe_backup(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DescribeBackup", request_body, content_type)
}

pub fn describe_continuous_backups(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "DescribeContinuousBackups",
    request_body,
    content_type,
  )
}

pub fn describe_contributor_insights(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "DescribeContributorInsights",
    request_body,
    content_type,
  )
}

pub fn describe_endpoints(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DescribeEndpoints", request_body, content_type)
}

pub fn describe_export(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DescribeExport", request_body, content_type)
}

pub fn describe_global_table(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DescribeGlobalTable", request_body, content_type)
}

pub fn describe_global_table_settings(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "DescribeGlobalTableSettings",
    request_body,
    content_type,
  )
}

pub fn describe_import(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DescribeImport", request_body, content_type)
}

pub fn describe_kinesis_streaming_destination(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "DescribeKinesisStreamingDestination",
    request_body,
    content_type,
  )
}

pub fn describe_limits(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DescribeLimits", request_body, content_type)
}

pub fn describe_table(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DescribeTable", request_body, content_type)
}

pub fn describe_table_replica_auto_scaling(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "DescribeTableReplicaAutoScaling",
    request_body,
    content_type,
  )
}

pub fn describe_time_to_live(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DescribeTimeToLive", request_body, content_type)
}

pub fn disable_kinesis_streaming_destination(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "DisableKinesisStreamingDestination",
    request_body,
    content_type,
  )
}

pub fn enable_kinesis_streaming_destination(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "EnableKinesisStreamingDestination",
    request_body,
    content_type,
  )
}

pub fn execute_statement(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ExecuteStatement", request_body, content_type)
}

pub fn execute_transaction(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ExecuteTransaction", request_body, content_type)
}

pub fn export_table_to_point_in_time(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "ExportTableToPointInTime",
    request_body,
    content_type,
  )
}

pub fn get_item(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetItem", request_body, content_type)
}

pub fn get_resource_policy(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetResourcePolicy", request_body, content_type)
}

pub fn import_table(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ImportTable", request_body, content_type)
}

pub fn list_backups(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListBackups", request_body, content_type)
}

pub fn list_contributor_insights(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "ListContributorInsights",
    request_body,
    content_type,
  )
}

pub fn list_exports(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListExports", request_body, content_type)
}

pub fn list_global_tables(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListGlobalTables", request_body, content_type)
}

pub fn list_imports(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListImports", request_body, content_type)
}

pub fn list_tables(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListTables", request_body, content_type)
}

pub fn list_tags_of_resource(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListTagsOfResource", request_body, content_type)
}

pub fn put_item(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "PutItem", request_body, content_type)
}

pub fn put_resource_policy(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "PutResourcePolicy", request_body, content_type)
}

pub fn query(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "Query", request_body, content_type)
}

pub fn restore_table_from_backup(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "RestoreTableFromBackup", request_body, content_type)
}

pub fn restore_table_to_point_in_time(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "RestoreTableToPointInTime",
    request_body,
    content_type,
  )
}

pub fn scan(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "Scan", request_body, content_type)
}

pub fn tag_resource(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "TagResource", request_body, content_type)
}

pub fn transact_get_items(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "TransactGetItems", request_body, content_type)
}

pub fn transact_write_items(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "TransactWriteItems", request_body, content_type)
}

pub fn untag_resource(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "UntagResource", request_body, content_type)
}

pub fn update_continuous_backups(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "UpdateContinuousBackups",
    request_body,
    content_type,
  )
}

pub fn update_contributor_insights(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "UpdateContributorInsights",
    request_body,
    content_type,
  )
}

pub fn update_global_table(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "UpdateGlobalTable", request_body, content_type)
}

pub fn update_global_table_settings(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "UpdateGlobalTableSettings",
    request_body,
    content_type,
  )
}

pub fn update_item(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "UpdateItem", request_body, content_type)
}

pub fn update_kinesis_streaming_destination(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "UpdateKinesisStreamingDestination",
    request_body,
    content_type,
  )
}

pub fn update_table(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "UpdateTable", request_body, content_type)
}

pub fn update_table_replica_auto_scaling(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "UpdateTableReplicaAutoScaling",
    request_body,
    content_type,
  )
}

pub fn update_time_to_live(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "UpdateTimeToLive", request_body, content_type)
}
