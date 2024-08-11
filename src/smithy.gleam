import decode.{type Decoder}
import gleam/dict.{type Dict}
import gleam/option.{type Option}

pub type ShapeId {
  ShapeId(String)
}

pub type Trait {
  TraitString(String)
  TraitInt(Int)
  TraitBool(Bool)
  TraitList(List(Trait))
  TraitDict(dict.Dict(ShapeId, Trait))
}

pub type Traits =
  Dict(ShapeId, Trait)

pub type Member {
  Member(target: ShapeId, traits: Traits)
}

pub type Reference {
  Reference(target: ShapeId)
}

pub type Service {
  Service(smithy: String, shapes: Dict(ShapeId, Shape))
}

pub type Shape {
  /// Simple
  Blob(traits: Traits)
  Bool(traits: Traits)
  String(traits: Traits)
  Byte(traits: Traits)
  Short(traits: Traits)
  Integer(traits: Traits)
  Long(traits: Traits)
  Float(traits: Traits)
  Double(traits: Traits)
  BigInteger(traits: Traits)
  BigDecimal(traits: Traits)
  Timestamp(traits: Traits)
  Document(traits: Traits)

  /// Aggregate
  List(traits: Traits, member: Member)
  Map(traits: Traits, key: Member, value: Member)
  Structure(traits: Traits, members: Dict(String, Member))
  Union(traits: Traits, members: Dict(String, Member))
  IntEnum(traits: Traits, members: Dict(String, Member))
  Enum(traits: Traits, members: Dict(String, Member))

  ServiceShape(
    version: String,
    operations: List(Reference),
    resources: List(Reference),
    errors: List(Reference),
    traits: Traits,
  )
  Resource(
    identifiers: Dict(String, Reference),
    properties: Dict(String, Reference),
    create: Reference,
    put: Reference,
    read: Reference,
    update: Reference,
    delete: Reference,
    list: Reference,
    operations: List(Reference),
    collection_operations: List(Reference),
    resources: List(Reference),
    traits: Traits,
  )
  Operation(
    input: Reference,
    output: Reference,
    errors: List(Reference),
    traits: Traits,
  )
}

pub fn service_decoder() -> Decoder(Service) {
  decode.into({
    use smithy <- decode.parameter
    use shapes <- decode.parameter
    Service(smithy, shapes)
  })
  |> decode.field("smithy", decode.string)
  |> decode.field("shapes", decode.dict(shape_id_decoder(), shape_decoder()))
}

fn shape_id_decoder() -> Decoder(ShapeId) {
  decode.map(decode.string, ShapeId)
}

fn reference_decoder() -> Decoder(Reference) {
  decode.into({
    use target <- decode.parameter
    Reference(target)
  })
  |> decode.field("target", shape_id_decoder())
}

fn member_decoder() -> decode.Decoder(Member) {
  decode.into({
    use target <- decode.parameter
    use traits <- decode.parameter
    Member(target, traits)
  })
  |> decode.field("target", shape_id_decoder())
  |> decode.field("traits", traits_decoder())
}

fn members_decoder() -> Decoder(Dict(String, Member)) {
  optional_dict_decoder(decode.string, member_decoder())
}

fn traits_decoder() {
  optional_dict_decoder(shape_id_decoder(), trait_decoder())
}

fn optional_dict_decoder(
  key: Decoder(k),
  value: Decoder(v),
) -> Decoder(Dict(k, v)) {
  let d = decode.optional(decode.dict(key, value))
  unwrap_decoder(d, dict.new())
}

fn unwrap_decoder(dec: Decoder(Option(t)), default: t) -> Decoder(t) {
  use opt <- decode.map(dec)
  option.unwrap(opt, default)
}

fn trait_decoder() -> decode.Decoder(Trait) {
  let int = decode.int |> decode.map(TraitInt)
  let string = decode.string |> decode.map(TraitString)
  let bool = decode.bool |> decode.map(TraitBool)
  let list = decode.list(lazy_trait_decoder()) |> decode.map(TraitList)
  let dict =
    decode.dict(shape_id_decoder(), lazy_trait_decoder())
    |> decode.map(TraitDict)
  decode.one_of([int, string, bool, list, dict])
}

fn lazy_trait_decoder() -> decode.Decoder(Trait) {
  decode.dynamic |> decode.then(fn(_) { trait_decoder() })
}

fn shape_decoder() -> Decoder(Shape) {
  let tpe = decode.at(["type"], decode.string)
  use tpe <- decode.then(tpe)
  case tpe {
    "blob" -> simple_decoder(Blob)
    "boolean" -> simple_decoder(Bool)
    "string" -> simple_decoder(String)
    "byte" -> simple_decoder(Byte)
    "short" -> simple_decoder(Short)
    "integer" -> simple_decoder(Integer)
    "long" -> simple_decoder(Long)
    "float" -> simple_decoder(Float)
    "double" -> simple_decoder(Double)
    "bigInteger" -> simple_decoder(BigInteger)
    "bigDecimal" -> simple_decoder(BigDecimal)
    "timestamp" -> simple_decoder(Timestamp)
    "document" -> simple_decoder(Document)

    "list" -> list_decoder()
    "map" -> map_decoder()
    "structure" -> structure_decoder()
    "union" -> union_decoder()
    "enum" -> enum_decoder()
    "intEnum" -> int_enum_decoder()

    "service" -> service_shape_decoder()
    "resource" -> resource_decoder()
    "operation" -> operation_decoder()
    _ -> decode.fail("unexpected shape")
  }
}

fn simple_decoder(constructor: fn(Traits) -> Shape) -> Decoder(Shape) {
  decode.into({
    use traits <- decode.parameter
    constructor(traits)
  })
  |> decode.field("traits", traits_decoder())
}

fn list_decoder() {
  decode.into({
    use traits <- decode.parameter
    use member <- decode.parameter
    List(traits, member)
  })
  |> decode.field("traits", traits_decoder())
  |> decode.field("member", member_decoder())
}

fn map_decoder() {
  decode.into({
    use traits <- decode.parameter
    use key <- decode.parameter
    use value <- decode.parameter
    Map(traits, key, value)
  })
  |> decode.field("traits", traits_decoder())
  |> decode.field("key", member_decoder())
  |> decode.field("value", member_decoder())
}

fn structure_decoder() {
  decode.into({
    use traits <- decode.parameter
    use members <- decode.parameter
    Structure(traits, members)
  })
  |> decode.field("traits", traits_decoder())
  |> decode.field("members", members_decoder())
}

fn union_decoder() {
  decode.into({
    use traits <- decode.parameter
    use members <- decode.parameter
    Union(traits, members)
  })
  |> decode.field("traits", traits_decoder())
  |> decode.field("members", members_decoder())
}

fn enum_decoder() {
  decode.into({
    use traits <- decode.parameter
    use members <- decode.parameter
    Enum(traits, members)
  })
  |> decode.field("traits", traits_decoder())
  |> decode.field("members", members_decoder())
}

fn int_enum_decoder() {
  decode.into({
    use traits <- decode.parameter
    use members <- decode.parameter
    IntEnum(traits, members)
  })
  |> decode.field("traits", traits_decoder())
  |> decode.field("members", members_decoder())
}

fn service_shape_decoder() {
  decode.into({
    use version <- decode.parameter
    use operations <- decode.parameter
    use resources <- decode.parameter
    use errors <- decode.parameter
    use traits <- decode.parameter
    ServiceShape(version, operations, resources, errors, traits)
  })
  |> decode.field("version", decode.string)
  |> decode.field("operations", optional_list(reference_decoder()))
  |> decode.field("resources", optional_list(reference_decoder()))
  |> decode.field("errors", optional_list(reference_decoder()))
  |> decode.field("traits", traits_decoder())
}

fn resource_decoder() {
  decode.into({
    use identifiers <- decode.parameter
    use properties <- decode.parameter
    use create <- decode.parameter
    use put <- decode.parameter
    use read <- decode.parameter
    use update <- decode.parameter
    use delete <- decode.parameter
    use list <- decode.parameter
    use operations <- decode.parameter
    use collection_operations <- decode.parameter
    use resources <- decode.parameter
    use traits <- decode.parameter
    Resource(
      identifiers,
      properties,
      create,
      put,
      read,
      update,
      delete,
      list,
      operations,
      collection_operations,
      resources,
      traits,
    )
  })
  |> decode.field(
    "identifiers",
    optional_dict_decoder(decode.string, reference_decoder()),
  )
  |> decode.field(
    "properties",
    optional_dict_decoder(decode.string, reference_decoder()),
  )
  |> decode.field("create", reference_decoder())
  |> decode.field("put", reference_decoder())
  |> decode.field("read", reference_decoder())
  |> decode.field("update", reference_decoder())
  |> decode.field("delete", reference_decoder())
  |> decode.field("list", reference_decoder())
  |> decode.field("operations", optional_list(reference_decoder()))
  |> decode.field("collection_operations", optional_list(reference_decoder()))
  |> decode.field("resources", optional_list(reference_decoder()))
  |> decode.field("traits", traits_decoder())
}

fn optional_list(dec: Decoder(t)) -> Decoder(List(t)) {
  unwrap_decoder(decode.optional(decode.list(dec)), [])
}

fn operation_decoder() {
  decode.into({
    use input <- decode.parameter
    use output <- decode.parameter
    use errors <- decode.parameter
    use traits <- decode.parameter
    Operation(input, output, errors, traits)
  })
  |> decode.field("input", reference_decoder())
  |> decode.field("output", reference_decoder())
  |> decode.field("errors", decode.list(reference_decoder()))
  |> decode.field("traits", traits_decoder())
}
