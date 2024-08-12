import gleam/bit_array
import gleam/dict
import gleam/json.{type Json}
import gleam/list
import utils.{encode_base64, encode_dict}
import x/dynamodb/types

pub fn json_bits(json: Json) -> BitArray {
  json
  |> json.to_string
  |> bit_array.from_string
}

pub fn get_item_input(input: types.GetItemInput) -> Json {
  json.object([
    #("TableName", json.string(input.table_name)),
    #("Key", encode_dict(input.key, attribute_value)),
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
      json.nullable(input.return_consumed_capacity, return_consumed_capacity(_)),
    ),
  ])
}

pub fn return_consumed_capacity(rcc: types.ReturnConsumedCapacity) -> Json {
  case rcc {
    types.Indexes -> json.string("INDEXES")
    types.Total -> json.string("TOTAL")
    types.None -> json.string("NONE")
  }
}

pub fn attribute_value(av: types.AttributeValue) -> Json {
  case av {
    types.B(b) -> {
      json.object([#("B", encode_base64(b))])
    }
    types.Bool(value) -> json.object([#("BOOL", json.bool(value))])
    types.BS(bs) -> {
      json.object([#("BS", json.array(bs, encode_base64))])
    }

    types.L(value) -> json.object([#("L", json.array(value, attribute_value))])

    types.M(value) -> {
      let value =
        value
        |> dict.to_list
        |> list.map(fn(kv) { #(kv.0, attribute_value(kv.1)) })
        |> json.object
      json.object([#("M", value)])
    }

    types.N(value) -> json.object([#("N", json.string(value))])
    types.NS(values) -> json.object([#("NS", json.array(values, json.string))])
    types.Null(value) -> json.object([#("NULL", json.bool(value))])
    types.S(value) -> json.object([#("S", json.string(value))])
    types.SS(values) -> json.object([#("SS", json.array(values, json.string))])
  }
}
