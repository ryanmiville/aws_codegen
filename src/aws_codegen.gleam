import codegen/endpoint_tests.{type TestCase, TestCase}
import codegen/module.{type Module, Json10, Json11}
import codegen/parse
import gleam/int
import gleam/string
import gleam_community/ansi
import internal/fileio
import internal/stringutils

import argv
import gleam/io
import gleam/list
import gleam/result
import smithy/service

pub fn main() {
  case argv.load().arguments {
    [] -> run_all()
    _ as filepaths -> run(filepaths)
  }
}

fn run_all() {
  let filepaths = fileio.get_files("./aws-models")
  run(filepaths)
}

fn run(filepaths: List(String)) {
  let files = list.map(filepaths, file)

  let #(supported, unsupported, errors) = partition(files)

  let supported = list.take(supported, 5)
  let test_cases = supported |> list.map(test_case)

  let written = supported |> list.map(write_module)

  let test_file_contents = endpoint_tests.make(test_cases)
  let test_file = "./test/aws/service/endpoint_test.gleam"
  fileio.write_file(test_file, test_file_contents)

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

  let len = list.length(unsupported)
  let message = "Skipped " <> int.to_string(len) <> " unsupported files"
  case len == 0 {
    True -> io.println(ansi.dim(message))
    False -> io.println(ansi.bright_blue(message))
  }

  let len = list.length(errors)
  let message = "Encountered " <> int.to_string(len) <> " errors"
  case len == 0 {
    True -> io.println(ansi.dim(message))
    False -> io.println(ansi.red(message))
  }
}

fn test_case(sup: Supported) -> TestCase {
  let module_name = module_name(sup)
  let shape_id = "com.amazonaws." <> module_name <> "#" <> sup.module.service_id
  TestCase(sup.path, shape_id, module_name)
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

fn module_name(supported: Supported) {
  let assert Ok(#(name, _)) =
    short_name(supported.path) |> string.split_once(".")
  stringutils.kebab_to_snake(name)
}

fn supported(module: Module) -> Bool {
  case module.protocol {
    Json10 | Json11 -> True
    _ -> False
  }
}

fn do_write_module(filename: String, module: Module) {
  let filepath = "./src/aws/service/" <> filename <> ".gleam"
  let contents = module.generate(module)
  fileio.write_file(filepath, contents)
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
