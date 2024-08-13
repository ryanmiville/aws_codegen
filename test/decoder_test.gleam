import decode
import gleam/json
import gleeunit
import gleeunit/should
import simplifile
import smithy/service

pub fn main() {
  gleeunit.main()
}

pub fn dynamodb_test() {
  let assert Ok(example) = simplifile.read("./aws-models/dynamodb.json")

  let decoder = service.decoder()
  let res = json.decode(example, decode.from(decoder, _))
  res
  |> should.be_ok
}
