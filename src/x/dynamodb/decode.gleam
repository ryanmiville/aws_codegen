import decode.{type Decoder}
import gleam/json
import utils.{decode_base64, lazy}
import x/dynamodb/types

pub fn from_json(json: BitArray, decoder: Decoder(t)) {
  let decode_fn = decode.from(decoder, _)
  json.decode_bits(json, decode_fn)
}

pub fn get_item_output() -> Decoder(types.GetItemOutput) {
  decode.into({
    use consumed_capacity <- decode.parameter
    use item <- decode.parameter
    types.GetItemOutput(consumed_capacity, item)
  })
  |> decode.field("ConsumedCapacity", decode.optional(consumed_capacity()))
  |> decode.field(
    "Item",
    decode.optional(decode.dict(decode.string, attribute_value())),
  )
}

fn consumed_capacity() -> Decoder(types.ConsumedCapacity) {
  decode.into({
    use capacity_units <- decode.parameter
    use global_secondary_indexes <- decode.parameter
    use local_secondary_indexes <- decode.parameter
    use read_capacity_units <- decode.parameter
    use table <- decode.parameter
    use table_name <- decode.parameter
    use write_capacity_units <- decode.parameter
    types.ConsumedCapacity(
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
    decode.dict(decode.string, capacity()),
  )
  |> decode.field(
    "LocalSecondaryIndexes",
    decode.dict(decode.string, capacity()),
  )
  |> decode.field("ReadCapacityUnits", decode.float)
  |> decode.field("Table", capacity())
  |> decode.field("TableName", decode.string)
  |> decode.field("WriteCapacityUnits", decode.float)
}

fn capacity() -> Decoder(types.Capacity) {
  decode.into({
    use capacity_units <- decode.parameter
    use read_capacity_units <- decode.parameter
    use write_capacity_units <- decode.parameter
    types.Capacity(capacity_units, read_capacity_units, write_capacity_units)
  })
  |> decode.field("CapacityUnits", decode.float)
  |> decode.field("ReadCapacityUnits", decode.float)
  |> decode.field("WriteCapacityUnits", decode.float)
}

pub fn attribute_value() -> Decoder(types.AttributeValue) {
  let decoders = [
    decode.at(["B"], decode_base64()) |> decode.map(types.B),
    decode.at(["BOOL"], decode.bool) |> decode.map(types.Bool),
    decode.at(["BS"], decode.list(decode_base64())) |> decode.map(types.BS),
    decode.at(["L"], decode.list(lazy(attribute_value))) |> decode.map(types.L),
    decode.at(["M"], decode.dict(decode.string, lazy(attribute_value)))
      |> decode.map(types.M),
    decode.at(["N"], decode.string) |> decode.map(types.N),
    decode.at(["NULL"], decode.bool) |> decode.map(types.Null),
    decode.at(["S"], decode.string) |> decode.map(types.S),
    decode.at(["SS"], decode.list(decode.string)) |> decode.map(types.SS),
  ]
  decode.one_of(decoders)
}

pub fn error() -> Decoder(types.Error) {
  decode.at(["message"], decode.string) |> decode.map(types.Error)
}
