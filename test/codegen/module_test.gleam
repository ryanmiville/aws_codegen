import codegen/module
import codegen/parse
import gleam/list
import gleam/result
import gleeunit
import gleeunit/should
import internal/fileio
import smithy/service

pub fn main() {
  gleeunit.main()
}

pub fn module_test() {
  fileio.read_file("./aws-models/dynamodb.json")
  |> service.from_json
  |> parse.services
  |> list.map(module.from)
  |> result.values
  |> should.equal([
    module.Module("DynamoDB_20120810", "dynamodb", "dynamodb", module.Json10, [
      "BatchExecuteStatement", "BatchGetItem", "BatchWriteItem", "CreateBackup",
      "CreateGlobalTable", "CreateTable", "DeleteBackup", "DeleteItem",
      "DeleteResourcePolicy", "DeleteTable", "DescribeBackup",
      "DescribeContinuousBackups", "DescribeContributorInsights",
      "DescribeEndpoints", "DescribeExport", "DescribeGlobalTable",
      "DescribeGlobalTableSettings", "DescribeImport",
      "DescribeKinesisStreamingDestination", "DescribeLimits", "DescribeTable",
      "DescribeTableReplicaAutoScaling", "DescribeTimeToLive",
      "DisableKinesisStreamingDestination", "EnableKinesisStreamingDestination",
      "ExecuteStatement", "ExecuteTransaction", "ExportTableToPointInTime",
      "GetItem", "GetResourcePolicy", "ImportTable", "ListBackups",
      "ListContributorInsights", "ListExports", "ListGlobalTables",
      "ListImports", "ListTables", "ListTagsOfResource", "PutItem",
      "PutResourcePolicy", "Query", "RestoreTableFromBackup",
      "RestoreTableToPointInTime", "Scan", "TagResource", "TransactGetItems",
      "TransactWriteItems", "UntagResource", "UpdateContinuousBackups",
      "UpdateContributorInsights", "UpdateGlobalTable",
      "UpdateGlobalTableSettings", "UpdateItem",
      "UpdateKinesisStreamingDestination", "UpdateTable",
      "UpdateTableReplicaAutoScaling", "UpdateTimeToLive",
    ]),
  ])
}

pub fn generate_test() {
  fileio.read_file("./aws-models/dynamodb.json")
  |> service.from_json
  |> parse.services
  |> list.map(module.from)
  |> result.values
  |> list.map(module.generate)
  |> list.length
  |> should.equal(1)
}
