import codegen/module.{type Module, Json10, Json11}
import codegen/parse
import fileio
import gleam/io
import gleam/list
import gleam/result
import smithy/service

pub fn main() {
  fileio.get_files("./aws-models")
  |> list.each(do_file)
}

fn do_file(filepath: String) {
  io.println("writing " <> filepath)
  fileio.read_file(filepath)
  |> service.from_json
  |> parse.services
  |> list.map(module.from)
  |> result.values
  |> list.filter(supported)
  |> list.each(write_module)
}

fn supported(module: Module) -> Bool {
  case module.protocol {
    Json10 | Json11 -> True
    _ -> False
  }
}

fn write_module(module: Module) {
  let _filepath = "./src/services/" <> module.endpoint_prefix <> ".gleam"
  let _contents = module.generate(module)
  // fileio.write_file(filepath, contents)
}
