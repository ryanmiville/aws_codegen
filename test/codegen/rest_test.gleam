import codegen/rest
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn build_uri_test() {
  let uri = "/{Bucket}/{Key+}?x-id=GetObject"

  let expect =
    "
  let path = string.concat([\"/\", bucket, \"/\", key, \"?x-id=GetObject\"])
  "
  rest.build_uri(uri)
  |> should.equal(expect)
}

pub fn op_params_test() {
  let uri = "/{Bucket}/{Key+}?x-id=GetObject"

  let expect = ["bucket", "key"]

  rest.op_params(uri)
  |> should.equal(expect)
}
