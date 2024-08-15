import aws/services/codecommit
import aws/services/dynamodb
import aws/services/healthlake
import aws/services/iotsecuretunneling
import aws/services/textract
import gleeunit
import helpers

pub fn main() {
  gleeunit.main()
}

pub fn codecommit_test() {
  helpers.test_endpoints(
    "./aws-models/codecommit.json",
    "com.amazonaws.codecommit#CodeCommit_20150413",
    codecommit.new,
  )
}

pub fn dynamodb_test() {
  helpers.test_endpoints(
    "./aws-models/dynamodb.json",
    "com.amazonaws.dynamodb#DynamoDB_20120810",
    dynamodb.new,
  )
}

pub fn iotsecuretunneling_test() {
  helpers.test_endpoints(
    "./aws-models/iotsecuretunneling.json",
    "com.amazonaws.iotsecuretunneling#IoTSecuredTunneling",
    iotsecuretunneling.new,
  )
}

pub fn healthlake_test() {
  helpers.test_endpoints(
    "./aws-models/healthlake.json",
    "com.amazonaws.healthlake#HealthLake",
    healthlake.new,
  )
}

pub fn textract_test() {
  helpers.test_endpoints(
    "./aws-models/textract.json",
    "com.amazonaws.textract#Textract",
    textract.new,
  )
}
