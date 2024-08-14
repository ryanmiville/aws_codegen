import codegen/module.{type Module, Json10, Json11}
import codegen/parse
import fileio
import gleam/string
import smithy/shape_id

import gleam/io
import gleam/list
import gleam/result
import smithy/service

pub fn main() {
  fileio.get_files("./aws-models")
  |> list.each(print_errors)
}

pub fn do_file(filepath: String) {
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
  let filepath = "./src/services/" <> module.endpoint_prefix <> ".gleam"
  let contents = module.generate(module)
  fileio.write_file(filepath, contents)
}

pub fn print_errors(filepath: String) {
  fileio.read_file(filepath)
  |> service.from_json
  |> parse.services
  |> list.map(module.from)
  |> errors
  |> list.each(print_error)
}

fn errors(results: List(Result(a, e))) -> List(e) {
  list.filter_map(results, fn(r) {
    case r {
      Ok(_) -> Error(Nil)
      Error(e) -> Ok(e)
    }
  })
}

fn print_error(error: module.Error) {
  let str =
    string.pad_right(error.message, 30, " ") <> shape_id.to_string(error.id)
  io.println_error(str)
}
