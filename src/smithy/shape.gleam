import decode.{type Decoder}
import gleam/dict.{type Dict}
import gleam/option.{type Option}
import smithy/shape_id.{type ShapeId}
import smithy/trait.{type Trait}

pub type Reference {
  Reference(target: ShapeId)
}

pub type Member {
  Member(target: ShapeId, traits: Traits)
}

pub type Traits =
  dict.Dict(ShapeId, Trait)

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

  Service(
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

pub fn reference_decoder() -> Decoder(Reference) {
  decode.into({
    use target <- decode.parameter
    Reference(target)
  })
  |> decode.field("target", shape_id.decoder())
}

fn member() -> decode.Decoder(Member) {
  decode.into({
    use target <- decode.parameter
    use traits <- decode.parameter
    Member(target, traits)
  })
  |> decode.field("target", shape_id.decoder())
  |> decode.field("traits", traits())
}

fn members() -> Decoder(Dict(String, Member)) {
  optional_dict(decode.string, member())
}

fn traits() {
  optional_dict(shape_id.decoder(), trait.decoder())
}

fn optional_dict(key: Decoder(k), value: Decoder(v)) -> Decoder(Dict(k, v)) {
  let d = decode.optional(decode.dict(key, value))
  unwrap(d, dict.new())
}

fn unwrap(dec: Decoder(Option(t)), default: t) -> Decoder(t) {
  use opt <- decode.map(dec)
  option.unwrap(opt, default)
}

pub fn decoder() -> Decoder(Shape) {
  let tpe = decode.at(["type"], decode.string)
  use tpe <- decode.then(tpe)
  case tpe {
    "blob" -> simple(Blob)
    "boolean" -> simple(Bool)
    "string" -> simple(String)
    "byte" -> simple(Byte)
    "short" -> simple(Short)
    "integer" -> simple(Integer)
    "long" -> simple(Long)
    "float" -> simple(Float)
    "double" -> simple(Double)
    "bigInteger" -> simple(BigInteger)
    "bigDecimal" -> simple(BigDecimal)
    "timestamp" -> simple(Timestamp)
    "document" -> simple(Document)

    "list" -> list()
    "map" -> map()
    "structure" -> structure()
    "union" -> union()
    "enum" -> enum()
    "intEnum" -> int_enum()

    "service" -> service()
    "resource" -> resource()
    "operation" -> operation()
    _ -> decode.fail("unexpected shape")
  }
}

fn simple(constructor: fn(Traits) -> Shape) -> Decoder(Shape) {
  decode.into({
    use traits <- decode.parameter
    constructor(traits)
  })
  |> decode.field("traits", traits())
}

fn list() {
  decode.into({
    use traits <- decode.parameter
    use member <- decode.parameter
    List(traits, member)
  })
  |> decode.field("traits", traits())
  |> decode.field("member", member())
}

fn map() {
  decode.into({
    use traits <- decode.parameter
    use key <- decode.parameter
    use value <- decode.parameter
    Map(traits, key, value)
  })
  |> decode.field("traits", traits())
  |> decode.field("key", member())
  |> decode.field("value", member())
}

fn structure() {
  decode.into({
    use traits <- decode.parameter
    use members <- decode.parameter
    Structure(traits, members)
  })
  |> decode.field("traits", traits())
  |> decode.field("members", members())
}

fn union() {
  decode.into({
    use traits <- decode.parameter
    use members <- decode.parameter
    Union(traits, members)
  })
  |> decode.field("traits", traits())
  |> decode.field("members", members())
}

fn enum() {
  decode.into({
    use traits <- decode.parameter
    use members <- decode.parameter
    Enum(traits, members)
  })
  |> decode.field("traits", traits())
  |> decode.field("members", members())
}

fn int_enum() {
  decode.into({
    use traits <- decode.parameter
    use members <- decode.parameter
    IntEnum(traits, members)
  })
  |> decode.field("traits", traits())
  |> decode.field("members", members())
}

fn service() {
  decode.into({
    use version <- decode.parameter
    use operations <- decode.parameter
    use resources <- decode.parameter
    use errors <- decode.parameter
    use traits <- decode.parameter
    Service(version, operations, resources, errors, traits)
  })
  |> decode.field("version", decode.string)
  |> decode.field("operations", optional_list(reference_decoder()))
  |> decode.field("resources", optional_list(reference_decoder()))
  |> decode.field("errors", optional_list(reference_decoder()))
  |> decode.field("traits", traits())
}

fn resource() {
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
    optional_dict(decode.string, reference_decoder()),
  )
  |> decode.field(
    "properties",
    optional_dict(decode.string, reference_decoder()),
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
  |> decode.field("traits", traits())
}

fn optional_list(dec: Decoder(t)) -> Decoder(List(t)) {
  unwrap(decode.optional(decode.list(dec)), [])
}

fn operation() {
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
  |> decode.field("traits", traits())
}
