import gleam/list
import gleam/regex.{type Match, Match}
import gleam/string

const pascal = "(^[A-Z])|[A-Z]"

pub fn pascal_to_snake(in string: String) -> String {
  let assert Ok(#(first, rest)) = string.pop_grapheme(string)
  string.lowercase(first) <> sub(rest, pascal, to_snake)
}

fn to_snake(match: Match) -> String {
  case match.content {
    "-" <> c | "_" <> c | c -> "_" <> string.lowercase(c)
  }
}

fn sub(
  in string: String,
  each pattern: String,
  with substitute: fn(Match) -> String,
) -> String {
  let assert Ok(re) = regex.from_string(pattern)
  let matches = regex.scan(re, string)
  let replacements = list.map(matches, fn(m) { #(m.content, substitute(m)) })

  list.fold(replacements, string, fn(acc, replacement) {
    let #(p, s) = replacement
    string.replace(acc, p, s)
  })
}
