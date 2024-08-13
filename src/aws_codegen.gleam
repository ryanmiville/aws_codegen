import codegen/module.{type Module}
import codegen/parse
import fileio
import gleam/io
import gleam/list
import smithy/service

pub fn main() {
  fileio.read_file("./aws-models/dynamodb.json")
  |> service.from_json
  |> parse.services
  |> list.map(module.from)
  |> list.each(write_module)
}

fn write_module(module: Module) {
  let filepath = "./src/services/" <> module.endpoint_prefix <> ".gleam"
  let contents = module.generate(module)

  io.println("writing " <> filepath)
  fileio.write_file(filepath, contents)
}
