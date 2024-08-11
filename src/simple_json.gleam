import decode
import simple.{
  type Member, type Reference, type Service, type SimpleShape, type Trait,
  Member, Reference, Service, SimpleShape, TBool, TDict, TInt, TList, TString,
}

pub fn simple_shape() -> decode.Decoder(SimpleShape) {
  decode.into({
    use type_ <- decode.parameter
    use mixins <- decode.parameter
    use version <- decode.parameter
    use resources <- decode.parameter
    use errors <- decode.parameter
    use traits <- decode.parameter
    use rename <- decode.parameter
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
    SimpleShape(
      type_,
      mixins,
      version,
      resources,
      errors,
      traits,
      rename,
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
    )
  })
  |> decode.field("type", decode.string)
  |> decode.field("mixins", decode.optional(decode.list(reference())))
  |> decode.field("version", decode.optional(decode.string))
  |> decode.field("resources", decode.optional(decode.list(reference())))
  |> decode.field("errors", decode.optional(decode.list(reference())))
  |> decode.field(
    "traits",
    decode.optional(decode.dict(decode.string, trait())),
  )
  |> decode.field(
    "rename",
    decode.optional(decode.dict(decode.string, decode.string)),
  )
  |> decode.field(
    "identifiers",
    decode.optional(decode.dict(decode.string, reference())),
  )
  |> decode.field(
    "properties",
    decode.optional(decode.dict(decode.string, reference())),
  )
  |> decode.field("create", decode.optional(reference()))
  |> decode.field("put", decode.optional(reference()))
  |> decode.field("read", decode.optional(reference()))
  |> decode.field("update", decode.optional(reference()))
  |> decode.field("delete", decode.optional(reference()))
  |> decode.field("list", decode.optional(reference()))
  |> decode.field("operations", decode.optional(decode.list(reference())))
  |> decode.field(
    "collectionOperations",
    decode.optional(decode.list(reference())),
  )
}

pub fn reference() -> decode.Decoder(Reference) {
  decode.into({
    use target <- decode.parameter
    Reference(target)
  })
  |> decode.field("target", decode.string)
}

pub fn member() -> decode.Decoder(Member) {
  decode.into({
    use target <- decode.parameter
    use traits <- decode.parameter
    Member(target, traits)
  })
  |> decode.field("target", decode.string)
  |> decode.field(
    "traits",
    decode.optional(decode.dict(decode.string, trait())),
  )
}

pub fn service() -> decode.Decoder(Service) {
  decode.into({
    use smithy <- decode.parameter
    use shapes <- decode.parameter
    Service(smithy, shapes)
  })
  |> decode.field("smithy", decode.string)
  |> decode.field("shapes", decode.dict(decode.string, simple_shape()))
}

pub fn trait() -> decode.Decoder(Trait) {
  let int = decode.int |> decode.map(TInt)
  let string = decode.string |> decode.map(TString)
  let bool = decode.bool |> decode.map(TBool)
  let list = decode.list(lazy_trait()) |> decode.map(TList)
  let dict = decode.dict(decode.string, lazy_trait()) |> decode.map(TDict)
  decode.one_of([int, string, bool, list, dict])
}

fn lazy_trait() -> decode.Decoder(Trait) {
  decode.dynamic |> decode.then(fn(_) { trait() })
}
