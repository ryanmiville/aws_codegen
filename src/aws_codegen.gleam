import gleam/dict.{type Dict}
import gleam/io
import gleam/option.{type Option}

pub type Service {
  Service(smithy: String, shapes: Dict(String, SimpleShape))
}

pub type Trait {
  TString(String)
  TInt(Int)
  TBool(Bool)
  TList(List(Trait))
  TDict(dict.Dict(String, Trait))
}

pub type Member {
  Member(target: String, traits: Option(Dict(String, Trait)))
}

pub type Reference {
  Reference(target: String)
}

// pub type Shape {
//   Shape(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//   )
//   /// Simple
//   Blob(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//   )
//   Boolean(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//   )
//   String(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//   )
//   Byte(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//   )
//   Short(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//   )
//   Integer(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//   )
//   IntEnum(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//     members: Dict(String, Member),
//   )
//   Enum(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//     members: Dict(String, Member),
//   )
//   Long(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//   )
//   Float(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//   )
//   Double(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//   )
//   BigInteger(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//   )
//   BigDecimal(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//   )
//   Timestamp(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//   )
//   Document(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//   )

//   /// Aggregate
//   ListShape(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//     member: Member,
//   )
//   Map(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//     key: Member,
//     value: Member,
//   )
//   Structure(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//     members: Option(Dict(String, Member)),
//   )
//   Union(
//     type_: String,
//     traits: Option(Dict(String, String)),
//     mixins: List(Reference),
//     members: Dict(String, Member),
//   )

//   /// Service
//   ServiceShape(
//     type_: String,
//     mixins: List(Reference),
//     version: String,
//     operations: List(Operation),
//     resources: List(Resource),
//     errors: List(Error),
//     //Shape = Structure
//     traits: Option(Dict(String, String)),
//     rename: Option(Dict(String, String)),
//   )
//   Resource(
//     type_: String,
//     mixins: List(Reference),
//     identifiers: Dict(String, Reference),
//     properties: Dict(String, Reference),
//     create: Reference,
//     put: Reference,
//     read: Reference,
//     update: Reference,
//     delete: Reference,
//     list: Reference,
//     operations: List(Operation),
//     collection_operations: List(Reference),
//     traits: Option(Dict(String, String)),
//   )
//   Operation(
//     type_: String,
//     mixins: List(Reference),
//     input: Reference,
//     output: Reference,
//     errors: List(Reference),
//     traits: Option(Dict(String, String)),
//   )

//   Apply(type_: String, traits: Option(Dict(String, String)))
// }

pub type SimpleShape {
  SimpleShape(
    type_: String,
    mixins: Option(List(Reference)),
    version: Option(String),
    resources: Option(List(Reference)),
    errors: Option(List(Reference)),
    //Shape = Structure
    traits: Option(Dict(String, Trait)),
    rename: Option(Dict(String, String)),
    identifiers: Option(Dict(String, Reference)),
    properties: Option(Dict(String, Reference)),
    create: Option(Reference),
    put: Option(Reference),
    read: Option(Reference),
    update: Option(Reference),
    delete: Option(Reference),
    list: Option(Reference),
    operations: Option(List(Reference)),
    collection_operations: Option(List(Reference)),
  )
}

pub fn main() {
  io.println("hello")
  // glerd_gen.record_info
  // |> glerd_json.generate("src", _)
}
