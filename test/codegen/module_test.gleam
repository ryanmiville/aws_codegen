import codegen/generate
import codegen/module
import codegen/parse
import gleam/list
import gleam/option.{None}
import gleam/result
import gleeunit
import gleeunit/should
import internal/fileio
import smithy/service

pub fn main() {
  gleeunit.main()
}

pub fn module_test() {
  let spec = fileio.read_file("./aws-models/dynamodb.json")
  let endpoint_spec = fileio.read_file("./aws-endpoints/aws-endpoints.json")
  spec
  |> service.from_json
  |> parse.services
  |> list.map(fn(s) { generate.module(s, spec, endpoint_spec) })
  |> result.values
  |> should.equal([
    module.Post(
      "DynamoDB_20120810",
      "dynamodb",
      "dynamodb",
      module.Json10,
      None,
      [
        "BatchExecuteStatement", "BatchGetItem", "BatchWriteItem",
        "CreateBackup", "CreateGlobalTable", "CreateTable", "DeleteBackup",
        "DeleteItem", "DeleteResourcePolicy", "DeleteTable", "DescribeBackup",
        "DescribeContinuousBackups", "DescribeContributorInsights",
        "DescribeEndpoints", "DescribeExport", "DescribeGlobalTable",
        "DescribeGlobalTableSettings", "DescribeImport",
        "DescribeKinesisStreamingDestination", "DescribeLimits", "DescribeTable",
        "DescribeTableReplicaAutoScaling", "DescribeTimeToLive",
        "DisableKinesisStreamingDestination",
        "EnableKinesisStreamingDestination", "ExecuteStatement",
        "ExecuteTransaction", "ExportTableToPointInTime", "GetItem",
        "GetResourcePolicy", "ImportTable", "ListBackups",
        "ListContributorInsights", "ListExports", "ListGlobalTables",
        "ListImports", "ListTables", "ListTagsOfResource", "PutItem",
        "PutResourcePolicy", "Query", "RestoreTableFromBackup",
        "RestoreTableToPointInTime", "Scan", "TagResource", "TransactGetItems",
        "TransactWriteItems", "UntagResource", "UpdateContinuousBackups",
        "UpdateContributorInsights", "UpdateGlobalTable",
        "UpdateGlobalTableSettings", "UpdateItem",
        "UpdateKinesisStreamingDestination", "UpdateTable",
        "UpdateTableReplicaAutoScaling", "UpdateTimeToLive",
      ],
    ),
  ])
}

pub fn generate_test() {
  let spec = fileio.read_file("./aws-models/dynamodb.json")
  let endpoint_spec = fileio.read_file("./aws-endpoints/aws-endpoints.json")
  spec
  |> service.from_json
  |> parse.services
  |> list.map(fn(s) { generate.module(s, spec, endpoint_spec) })
  |> result.values
  |> list.map(generate.code)
  |> list.length
  |> should.equal(1)
}
