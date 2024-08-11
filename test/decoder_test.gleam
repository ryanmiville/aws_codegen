import decode
import gleam/json
import gleeunit
import gleeunit/should
import simplifile
import smithy/service

pub fn main() {
  gleeunit.main()
}

pub fn kinesis_video_webrtc_storage_test() {
  let assert Ok(example) =
    simplifile.read("./aws-models/kinesis-video-webrtc-storage.json")

  let decoder = service.decoder()
  let res = json.decode(example, decode.from(decoder, _))
  res
  |> should.be_ok
}
