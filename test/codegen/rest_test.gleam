import codegen/rest
import decode
import gleam/json
import gleeunit
import gleeunit/should
import internal/fileio

pub fn main() {
  gleeunit.main()
}

// pub fn operation_test() {
//   let decoder = rest.operation("com.amazonaws.s3#GetObject")

//   let contents = fileio.read_file("./aws-models/s3.json")
//   let op = json.decode(contents, decode.from(decoder, _))

//   let expect = rest.Operation("GET", "/{Bucket}/{Key+}?x-id=GetObject", 200)
//   op |> should.equal(Ok(expect))
// }

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
