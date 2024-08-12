import gleam/dict.{type Dict}
import gleam/option.{type Option}

pub type AttributeValue {
  B(b: BitArray)
  Bool(bool: Bool)
  BS(bs: List(BitArray))
  L(l: List(AttributeValue))
  M(m: Dict(String, AttributeValue))
  N(n: String)
  NS(ns: List(String))
  Null(null: Bool)
  S(s: String)
  SS(ss: List(String))
}

pub type ReturnConsumedCapacity {
  Indexes
  Total
  None
}

pub type GetItemInput {
  GetItemInput(
    table_name: String,
    key: Dict(String, AttributeValue),
    attributes_to_get: Option(List(String)),
    consistent_read: Option(Bool),
    expression_attribute_names: Option(Dict(String, String)),
    projection_expression: Option(String),
    return_consumed_capacity: Option(ReturnConsumedCapacity),
  )
}

pub type Capacity {
  Capacity(
    capacity_units: Float,
    read_capacity_units: Float,
    write_capacity_units: Float,
  )
}

pub type ConsumedCapacity {
  ConsumedCapacity(
    capacity_units: Float,
    global_secondary_indexes: Dict(String, Capacity),
    local_secondary_indexes: Dict(String, Capacity),
    read_capacity_units: Float,
    table: Capacity,
    table_name: String,
    write_capacity_units: Float,
  )
}

pub type GetItemOutput {
  GetItemOutput(
    consumed_capacity: Option(ConsumedCapacity),
    item: Option(Dict(String, AttributeValue)),
  )
}

pub type Error {
  Error(message: String)
}
