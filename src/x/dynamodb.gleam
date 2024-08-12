import decode.{type Decoder}
import gleam/bit_array
import gleam/dict.{type Dict}
import gleam/http
import gleam/http/request.{type Request, Request}
import gleam/httpc
import gleam/json.{type Json}
import gleam/list
import gleam/option.{type Option}
import gleam/result
import gleam/string
import pprint
import x/client
import x/time

pub fn get_item_req() -> Request(BitArray) {
  let body =
    json.object([
      #("TableName", json.string("doorman-production-WaitlistTable")),
      #(
        "Key",
        json.object([
          #(
            "email",
            json.object([#("S", json.string("ryanmiville@gmail.com"))]),
          ),
        ]),
      ),
    ])
    |> json.to_string
    |> bit_array.from_string

  let assert Ok(request) =
    request.to("https://dynamodb.us-east-1.amazonaws.com/")
  let request =
    request.Request(
      ..request,
      headers: [
        #("host", "dynamodb.us-east-1.amazonaws.com"),
        #("X-Amz-Target", "DynamoDB_20120810.GetItem"),
        #("content-type", "application/x-amz-json-1.0"),
      ],
    )

  request
  |> request.set_method(http.Post)
  |> request.set_body(body)
}

pub type StringAttributeValue =
  String

pub type NumberAttributeValue =
  String

pub type AttributeValue {
  B(b: BitArray)
  Bool(bool: Bool)
  BS(bs: List(BitArray))
  L(l: List(AttributeValue))
  M(m: Dict(AttributeName, AttributeValue))
  N(n: NumberAttributeValue)
  NS(ns: List(NumberAttributeValue))
  Null(null: Bool)
  S(s: StringAttributeValue)
  SS(ss: List(StringAttributeValue))
}

pub type ReturnConsumedCapacity {
  Indexes
  Total
  None
}

pub type Key =
  Dict(AttributeName, AttributeValue)

pub type AttributeNameList =
  List(AttributeName)

pub type ConsistentRead =
  Bool

pub type ProjectionExpression =
  String

pub type GetItemInput {
  GetItemInput(
    table_name: TableArn,
    key: Key,
    attributes_to_get: Option(AttributeNameList),
    consistent_read: Option(ConsistentRead),
    expression_attribute_names: Option(ExpressionAttributeNameMap),
    projection_expression: Option(ProjectionExpression),
    return_consumed_capacity: Option(ReturnConsumedCapacity),
  )
}

pub type ExpressionAttributeNameVariable =
  String

pub type ExpressionAttributeNameMap =
  Dict(ExpressionAttributeNameVariable, AttributeName)

pub type Capacity {
  Capacity(
    capacity_units: ConsumedCapacityUnits,
    read_capacity_units: ConsumedCapacityUnits,
    write_capacity_units: ConsumedCapacityUnits,
  )
}

pub type TableArn =
  String

pub type ConsumedCapacityUnits =
  Float

pub type IndexName =
  String

pub type AttributeName =
  String

pub type SecondaryIndexesCapacityMap =
  Dict(IndexName, Capacity)

pub type ConsumedCapacity {
  ConsumedCapacity(
    capacity_units: ConsumedCapacityUnits,
    global_secondary_indexes: SecondaryIndexesCapacityMap,
    local_secondary_indexes: SecondaryIndexesCapacityMap,
    read_capacity_units: ConsumedCapacityUnits,
    table: Capacity,
    table_name: TableArn,
    write_capacity_units: ConsumedCapacityUnits,
  )
}

pub type AttributeMap =
  Dict(AttributeName, AttributeValue)

pub type GetItemOutput {
  GetItemOutput(
    consumed_capacity: Option(ConsumedCapacity),
    item: Option(AttributeMap),
  )
}

pub type Error {
  Error(msg: String)
}

pub type Client {
  Client(
    access_key_id: String,
    secret_access_key: String,
    region: String,
    service: String,
  )
}

pub fn new(
  access_key_id: String,
  secret_access_key: String,
  region: String,
) -> Client {
  Client(access_key_id, secret_access_key, region, "dynamodb")
}

pub fn get_item(
  client: Client,
  input: GetItemInput,
) -> Result(GetItemOutput, Error) {
  let body =
    get_item_input_encoder(input)
    |> json.to_string
    |> bit_array.from_string

  let assert Ok(request) =
    request.to("https://dynamodb.us-east-1.amazonaws.com/")
  let request =
    request.Request(
      ..request,
      headers: [
        #("host", "dynamodb.us-east-1.amazonaws.com"),
        #("X-Amz-Target", "DynamoDB_20120810.GetItem"),
        #("content-type", "application/x-amz-json-1.0"),
      ],
    )
    |> request.set_method(http.Post)
    |> request.set_body(body)

  let resp =
    client.sign(
      request,
      time.utc_now(),
      client.access_key_id,
      client.secret_access_key,
      client.region,
      client.service,
    )
    |> httpc.send_bits
    |> pprint.debug

  let resp = result.map_error(resp, error)
  use res <- result.try(resp)
  let body = res.body
  let str = bit_array.to_string(body)
  let str = result.map_error(str, error)
  use json_string: String <- result.try(str)
  let decode_fn = decode.from(decoder(), _)
  let decoded = json.decode(json_string, decode_fn)
  result.map_error(decoded, error)
}

pub fn decoder() -> Decoder(GetItemOutput) {
  decode.into({
    use consumed_capacity <- decode.parameter
    use item <- decode.parameter
    GetItemOutput(consumed_capacity, item)
  })
  |> decode.field(
    "ConsumedCapacity",
    decode.optional(consumed_capacity_decoder()),
  )
  |> decode.field(
    "Item",
    decode.optional(decode.dict(decode.string, av_decoder())),
  )
}

fn consumed_capacity_decoder() -> Decoder(ConsumedCapacity) {
  decode.into({
    use capacity_units <- decode.parameter
    use global_secondary_indexes <- decode.parameter
    use local_secondary_indexes <- decode.parameter
    use read_capacity_units <- decode.parameter
    use table <- decode.parameter
    use table_name <- decode.parameter
    use write_capacity_units <- decode.parameter
    ConsumedCapacity(
      capacity_units,
      global_secondary_indexes,
      local_secondary_indexes,
      read_capacity_units,
      table,
      table_name,
      write_capacity_units,
    )
  })
  |> decode.field("CapacityUnits", decode.float)
  |> decode.field(
    "GlobalSecondaryIndexes",
    decode.dict(decode.string, capacity_decoder()),
  )
  |> decode.field(
    "LocalSecondaryIndexes",
    decode.dict(decode.string, capacity_decoder()),
  )
  |> decode.field("ReadCapacityUnits", decode.float)
  |> decode.field("Table", capacity_decoder())
  |> decode.field("TableName", decode.string)
  |> decode.field("WriteCapacityUnits", decode.float)
}

fn capacity_decoder() -> Decoder(Capacity) {
  decode.into({
    use capacity_units <- decode.parameter
    use read_capacity_units <- decode.parameter
    use write_capacity_units <- decode.parameter
    Capacity(capacity_units, read_capacity_units, write_capacity_units)
  })
  |> decode.field("CapacityUnits", decode.float)
  |> decode.field("ReadCapacityUnits", decode.float)
  |> decode.field("WriteCapacityUnits", decode.float)
}

pub fn get_item_input_encoder(input: GetItemInput) -> Json {
  json.object([
    #("TableName", json.string(input.table_name)),
    #("Key", encode_dict(input.key, attribute_value_encoder)),
    #(
      "AttributesToGet",
      json.nullable(input.attributes_to_get, json.array(_, json.string)),
    ),
    #(
      "ProjectionExpression",
      json.nullable(input.projection_expression, json.string),
    ),
    #(
      "ReturnConsumedCapacity",
      json.nullable(
        input.return_consumed_capacity,
        return_consumed_capacity_encoder(_),
      ),
    ),
  ])
}

fn encode_dict(input: Dict(String, v), f: fn(v) -> Json) -> Json {
  dict.to_list(input)
  |> list.map(fn(kv) {
    let #(k, v) = kv
    #(k, f(v))
  })
  |> json.object
}

fn return_consumed_capacity_encoder(rcc: ReturnConsumedCapacity) -> Json {
  case rcc {
    Indexes -> json.string("INDEXES")
    Total -> json.string("TOTAL")
    None -> json.string("NONE")
  }
}

fn binary_encode(bytes: BitArray) -> Json {
  bit_array.base64_encode(bytes, False)
  |> json.string
}

pub fn attribute_value_encoder(av: AttributeValue) -> Json {
  case av {
    B(b) -> {
      json.object([#("B", binary_encode(b))])
    }
    Bool(value) -> json.object([#("BOOL", json.bool(value))])
    BS(bs) -> {
      json.object([#("BS", json.array(bs, binary_encode))])
    }

    L(value) ->
      json.object([#("L", json.array(value, attribute_value_encoder))])

    M(value) -> {
      let value =
        value
        |> dict.to_list
        |> list.map(fn(kv) { #(kv.0, attribute_value_encoder(kv.1)) })
        |> json.object
      json.object([#("M", value)])
    }

    N(value) -> json.object([#("N", json.string(value))])
    NS(values) -> json.object([#("NS", json.array(values, json.string))])
    Null(value) -> json.object([#("NULL", json.bool(value))])
    S(value) -> json.object([#("S", json.string(value))])
    SS(values) -> json.object([#("SS", json.array(values, json.string))])
  }
}

pub fn av_decoder() -> Decoder(AttributeValue) {
  let decoders = [
    do_av("B", decode.bit_array, B),
    do_av("BOOL", decode.bool, Bool),
    do_av("BS", decode.list(decode.bit_array), BS),
    do_av("L", decode.list(lazy(av_decoder)), L),
    do_av("M", decode.dict(decode.string, lazy(av_decoder)), M),
    do_av("N", decode.string, N),
    do_av("NULL", decode.bool, Null),
    do_av("S", decode.string, S),
    do_av("SS", decode.list(decode.string), SS),
  ]
  decode.one_of(decoders)
}

fn lazy(f: fn() -> Decoder(t)) -> Decoder(t) {
  decode.dynamic |> decode.then(fn(_) { f() })
}

fn do_av(
  field_name: String,
  decoder: Decoder(t),
  f: fn(t) -> AttributeValue,
) -> Decoder(AttributeValue) {
  decode.at([field_name], decoder) |> decode.map(f)
}

fn error(value: a) -> Error {
  string.inspect(value) |> Error
}
