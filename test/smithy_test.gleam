import decode
import gleam/json
import gleeunit
import gleeunit/should
import pprint
import smithy

import simplifile

pub fn main() {
  gleeunit.main()
}

pub fn kinesis_video_webrtc_storage_test() {
  let assert Ok(example) =
    simplifile.read("./aws-models/kinesis-video-webrtc-storage.json")

  let decoder = smithy.service_decoder()
  let res = json.decode(example, decode.from(decoder, _))
  res
  |> pprint.debug
  |> should.be_ok
}
