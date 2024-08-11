import decode
import gleam/json
import gleeunit
import gleeunit/should
import simple_json

import simplifile

pub fn main() {
  gleeunit.main()
}

pub fn kinesis_video_webrtc_storage_test() {
  let assert Ok(example) =
    simplifile.read("./aws-models/kinesis-video-webrtc-storage.json")

  let decoder = simple_json.service()
  let res = json.decode(example, decode.from(decoder, _))
  res
  |> should.be_ok
}
