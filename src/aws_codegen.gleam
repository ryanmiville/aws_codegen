import codegen/generate
import codegen/module.{type Module, Json10, Json11, RestJson1, RestXml}
import codegen/parse
import gleam/int
import gleam/string
import gleam_community/ansi
import internal/fileio
import internal/stringutils

import argv
import gleam/io
import gleam/list
import gleam/otp/task
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
  // let files = list.map(filepaths, file)
  let results = run_tasks(filepaths)

  // let #(supported, unsupported, errors) = partition(files)

  let #(validated, errors) = result.partition(results)
  let #(written, unsupported) =
    list.partition(validated, fn(v) {
      case v {
        Written(_, _) -> True
        _ -> False
      }
    })

  verbose(written, unsupported, errors)
  output(written, unsupported, errors)
}

fn run_tasks(filepaths: List(String)) -> List(Result(Validated, Err)) {
  let tasks = list.map(filepaths, fn(fp) { task.async(fn() { run_file(fp) }) })
  let results = list.map(tasks, task.await_forever)
  use res <- list.map(results)
  use res <- result.map(res)
  case res {
    Supported(_, _) as supported -> {
      write_module(supported)
    }
    other -> other
  }
}

fn run_file(filepath: String) -> Result(Validated, Err) {
  let file = file(filepath)
  let module = file.module |> result.map_error(fn(err) { Err(filepath, err) })
  use module <- result.try(module)
  case supported(module) {
    True -> {
      Ok(Supported(file.path, module))
    }
    False -> Ok(Unsupported(file.path, module.protocol))
  }
}

fn output(
  written: List(Validated),
  unsupported: List(Validated),
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

fn verbose(
  written: List(Validated),
  unsupported: List(Validated),
  errors: List(Err),
) {
  io.println(ansi.green("Successfully wrote:\n"))
  list.each(written, print_written)

  io.println(ansi.bright_blue("Unsupported protocol:\n"))
  list.each(unsupported, print_unsupported)

  io.println(ansi.red("Errors:\n"))
  list.each(errors, print_error)
}

fn print_written(written: Validated) {
  io.println(ansi.green(written.path))
}

// fn partition(
//   files: List(File),
// ) -> #(List(Supported), List(Unsupported), List(Err)) {
//   list.fold(files, #([], [], []), fn(acc, file) {
//     let #(s, u, e) = acc
//     case file.module {
//       Error(err) -> #(s, u, [Err(file.path, err), ..e])
//       Ok(module) ->
//         case supported(module) {
//           True -> #([Supported(file.path, module), ..s], u, e)
//           False -> #(s, [Unsupported(file.path, module.protocol), ..u], e)
//         }
//     }
//   })
// }

type File {
  File(path: String, module: Result(Module, module.Error))
}

type Validated {
  Written(path: String, module: Module)
  Supported(path: String, module: Module)
  Unsupported(path: String, protocol: module.Protocol)
}

type Err {
  Err(path: String, error: module.Error)
}

fn file(filepath: String) {
  io.println(ansi.dim("parsing " <> filepath <> "..."))
  let spec = fileio.read_file(filepath)
  let assert [service] =
    service.from_json(spec)
    |> parse.services

  File(filepath, generate.module(service, spec))
}

fn write_module(supported: Validated) {
  let assert Ok(#(name, _)) =
    short_name(supported.path) |> string.split_once(".")
  let name = stringutils.kebab_to_snake(name)
  let assert Supported(_, module) = supported
  do_write_module(name, module)
}

fn supported(module: Module) -> Bool {
  case module.protocol {
    RestXml | RestJson1 | Json10 | Json11 -> True
    _ -> False
  }
}

fn do_write_module(filename: String, module: Module) {
  let filepath = "./src/aws/x/service/" <> filename <> ".gleam"
  let contents = generate.code(module)
  fileio.write_file(filepath, contents)
  Written(filepath, module)
}

fn print_error(err: Err) {
  let msg = string.pad_right(err.error.message, 30, " ")
  let path = short_name(err.path)
  io.println_error(ansi.red(msg <> " | " <> path))
}

fn print_unsupported(un: Validated) {
  let path = short_name(un.path)
  let assert Unsupported(_, protocol) = un
  let protocol = string.pad_right(string.inspect(protocol), 20, " ")
  io.println(ansi.bright_blue(protocol <> " | " <> path))
}

fn short_name(filepath: String) {
  string.split(filepath, "/")
  |> list.last
  |> result.unwrap(filepath)
}
