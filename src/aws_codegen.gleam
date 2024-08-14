import codegen/module.{type Module, Json10, Json11}
import codegen/parse
import fileio
import gleam/int
import gleam/string
import gleam_community/ansi
import stringutils

import gleam/io
import gleam/list
import gleam/result
import smithy/service

pub fn main() {
  run()
}

fn run() {
  let files =
    fileio.get_files("./aws-models")
    |> list.map(file)

  let #(supported, unsupported, errors) = partition(files)

  let written = list.map(supported, write_module)

  verbose(written, unsupported, errors)
  output(written, unsupported, errors)
}

fn output(
  written: List(Written),
  unsupported: List(Unsupported),
  errors: List(Err),
) {
  let len = list.length(written) |> int.to_string
  io.println(ansi.green("Successfully wrote " <> len <> " files"))

  let len = list.length(unsupported) |> int.to_string
  io.println(ansi.bright_blue("Skipped " <> len <> " unsupported files"))

  let len = list.length(errors) |> int.to_string
  io.println(ansi.red("Encountered " <> len <> " errors"))
}

fn verbose(
  written: List(Written),
  unsupported: List(Unsupported),
  errors: List(Err),
) {
  io.println(ansi.green("Successfully wrote:\n"))
  list.each(written, print_written)

  io.println(ansi.bright_blue("Unsupported protocol:\n"))
  list.each(unsupported, print_unsupported)

  io.println(ansi.red("Errors:\n"))
  list.each(errors, print_error)
}

fn print_written(written: Written) {
  io.println(ansi.green(written.path))
}

fn partition(
  files: List(File),
) -> #(List(Supported), List(Unsupported), List(Err)) {
  list.fold(files, #([], [], []), fn(acc, file) {
    let #(s, u, e) = acc
    case file.module {
      Error(err) -> #(s, u, [Err(file.path, err), ..e])
      Ok(module) ->
        case supported(module) {
          True -> #([Supported(file.path, module), ..s], u, e)
          False -> #(s, [Unsupported(file.path, module.protocol), ..u], e)
        }
    }
  })
}

type File {
  File(path: String, module: Result(Module, module.Error))
}

type Supported {
  Supported(path: String, module: Module)
}

type Written {
  Written(path: String, module: Module)
}

type Unsupported {
  Unsupported(path: String, protocol: module.Protocol)
}

type Err {
  Err(path: String, error: module.Error)
}

fn file(filepath: String) {
  io.println(ansi.dim("parsing " <> filepath <> "..."))
  let assert [service] =
    fileio.read_file(filepath)
    |> service.from_json
    |> parse.services

  File(filepath, module.from(service))
}

fn write_module(supported: Supported) {
  let assert Ok(#(name, _)) =
    short_name(supported.path) |> string.split_once(".")
  let name = stringutils.kebab_to_snake(name)
  do_write_module(name, supported.module)
}

fn supported(module: Module) -> Bool {
  case module.protocol {
    Json10 | Json11 -> True
    _ -> False
  }
}

fn do_write_module(filename: String, module: Module) {
  let filepath = "./src/services/" <> filename <> ".gleam"
  let _contents = module.generate(module)
  // fileio.write_file(filepath, contents)
  Written(filepath, module)
}

fn print_error(err: Err) {
  let msg = string.pad_right(err.error.message, 30, " ")
  let path = short_name(err.path)
  io.println_error(ansi.red(msg <> " | " <> path))
}

fn print_unsupported(un: Unsupported) {
  let path = short_name(un.path)
  let protocol = string.pad_right(string.inspect(un.protocol), 20, " ")
  io.println(ansi.bright_blue(protocol <> " | " <> path))
}

fn short_name(filepath: String) {
  string.split(filepath, "/")
  |> list.last
  |> result.unwrap(filepath)
}
