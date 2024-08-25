import gleam/list
import gleam/option.{Some}
import gleam/regex.{type Match, Match}
import gleam/string

const kebab = "-([a-zA-Z0-9])"

pub fn kebab_to_snake(in string: String) -> String {
  sub(string, kebab, to_snake)
}

fn to_snake(match: Match) -> String {
  case match.content {
    "-" <> c | "_" <> c | c -> "_" <> string.lowercase(c)
  }
}

pub fn pascal_to_snake(input: String) -> String {
  do_pascal_to_snake(input, "([a-z0-9])([A-Z])")
  |> do_pascal_to_snake("([A-Z]+)([A-Z][a-z])")
  |> string.lowercase
}

fn do_pascal_to_snake(input: String, pattern: String) -> String {
  use match <- sub(input, pattern)
  let assert [Some(a), Some(b)] = match.submatches
  a <> "_" <> b
}

pub fn sub(
  in string: String,
  each pattern: String,
  with substitute: fn(Match) -> String,
) -> String {
  let assert Ok(re) = regex.from_string(pattern)
  let matches = regex.scan(re, string)
  let replacements = list.map(matches, fn(m) { #(m.content, substitute(m)) })

  use acc, replacement <- list.fold(replacements, string)
  let #(p, s) = replacement
  string.replace(acc, p, s)
}
