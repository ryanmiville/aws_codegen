import gleam/list
import gleam/string

pub type TestCase {
  TestCase(filepath: String, shape_id: String, module_name: String)
}

pub fn make(test_cases: List(TestCase)) {
  let imports = test_cases |> list.map(fn(t) { t.module_name }) |> imports

  let test_cases = list.map(test_cases, make_one) |> string.join("\n")

  imports <> "\n\n" <> mn <> test_cases
}

pub fn make_one(t: TestCase) {
  template
  |> string.replace("MODULE_NAME", t.module_name)
  |> string.replace("FILEPATH", t.filepath)
  |> string.replace("SHAPE_ID", t.shape_id)
}

const mn = "
pub fn main() {
  gleeunit.main()
}

"

const template = "
pub fn MODULE_NAME_test() {
  helpers.test_endpoints(
    \"FILEPATH\",
    \"SHAPE_ID\",
    MODULE_NAME.new,
  )
}

"

fn imports(modules: List(String)) {
  let svcs = list.map(modules, do_import)
  ["import gleeunit", "import helpers", ..svcs]
  |> string.join("\n")
}

fn do_import(module: String) {
  "import aws/service/" <> module
}
