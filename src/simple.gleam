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
