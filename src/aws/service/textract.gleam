import aws/aws
import aws/client.{type Client}
import aws/config.{type Config}
import aws/internal/endpoint

const content_type = "application/x-amz-json-1.1"

const endpoint_prefix = "textract"

const service_id = "Textract"

const signing_name = "textract"

pub fn new(config: Config) -> Client {
  let endpoint = endpoint.resolve(config, endpoint_prefix)
  client.Client(config, service_id, signing_name, endpoint)
}

pub fn analyze_document(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "AnalyzeDocument", request_body, content_type)
}

pub fn analyze_expense(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "AnalyzeExpense", request_body, content_type)
}

pub fn analyze_i_d(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "AnalyzeID", request_body, content_type)
}

pub fn create_adapter(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "CreateAdapter", request_body, content_type)
}

pub fn create_adapter_version(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "CreateAdapterVersion", request_body, content_type)
}

pub fn delete_adapter(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DeleteAdapter", request_body, content_type)
}

pub fn delete_adapter_version(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DeleteAdapterVersion", request_body, content_type)
}

pub fn detect_document_text(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DetectDocumentText", request_body, content_type)
}

pub fn get_adapter(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetAdapter", request_body, content_type)
}

pub fn get_adapter_version(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetAdapterVersion", request_body, content_type)
}

pub fn get_document_analysis(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetDocumentAnalysis", request_body, content_type)
}

pub fn get_document_text_detection(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "GetDocumentTextDetection",
    request_body,
    content_type,
  )
}

pub fn get_expense_analysis(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetExpenseAnalysis", request_body, content_type)
}

pub fn get_lending_analysis(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetLendingAnalysis", request_body, content_type)
}

pub fn get_lending_analysis_summary(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "GetLendingAnalysisSummary",
    request_body,
    content_type,
  )
}

pub fn list_adapters(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListAdapters", request_body, content_type)
}

pub fn list_adapter_versions(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListAdapterVersions", request_body, content_type)
}

pub fn list_tags_for_resource(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListTagsForResource", request_body, content_type)
}

pub fn start_document_analysis(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "StartDocumentAnalysis", request_body, content_type)
}

pub fn start_document_text_detection(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "StartDocumentTextDetection",
    request_body,
    content_type,
  )
}

pub fn start_expense_analysis(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "StartExpenseAnalysis", request_body, content_type)
}

pub fn start_lending_analysis(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "StartLendingAnalysis", request_body, content_type)
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

pub fn update_adapter(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "UpdateAdapter", request_body, content_type)
}
