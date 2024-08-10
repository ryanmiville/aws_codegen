// // this file was generated via "gleam run -m glerd"

// import glerd/types

// pub const record_info = [
//   #(
//     "SimpleShape",
//     "aws_codegen",
//     [
//       #("type_", types.IsString),
//       #("mixins", types.IsOption(types.IsList(types.IsRecord("Reference")))),
//       #("version", types.IsOption(types.IsString)),
//       #("resources", types.IsOption(types.IsList(types.IsRecord("Reference")))),
//       #("errors", types.IsOption(types.IsList(types.IsRecord("Reference")))),
//       #("traits", types.IsOption(types.IsDict(types.IsString, types.IsString))),
//       #("rename", types.IsOption(types.IsDict(types.IsString, types.IsString))),
//       #(
//         "identifiers",
//         types.IsOption(
//           types.IsDict(types.IsString, types.IsRecord("Reference")),
//         ),
//       ),
//       #(
//         "properties",
//         types.IsOption(
//           types.IsDict(types.IsString, types.IsRecord("Reference")),
//         ),
//       ), #("create", types.IsOption(types.IsRecord("Reference"))),
//       #("put", types.IsOption(types.IsRecord("Reference"))),
//       #("read", types.IsOption(types.IsRecord("Reference"))),
//       #("update", types.IsOption(types.IsRecord("Reference"))),
//       #("delete", types.IsOption(types.IsRecord("Reference"))),
//       #("list", types.IsOption(types.IsRecord("Reference"))),
//       #("operations", types.IsOption(types.IsList(types.IsRecord("Reference")))),
//       #(
//         "collection_operations",
//         types.IsOption(types.IsList(types.IsRecord("Reference"))),
//       ),
//     ],
//     "",
//   ), #("Reference", "aws_codegen", [#("target", types.IsString)], ""),
//   #(
//     "Member",
//     "aws_codegen",
//     [
//       #("target", types.IsString),
//       #("traits", types.IsOption(types.IsDict(types.IsString, types.IsString))),
//     ],
//     "",
//   ),
//   #(
//     "Service",
//     "aws_codegen",
//     [
//       #("smithy", types.IsString),
//       #("shapes", types.IsDict(types.IsString, types.IsRecord("SimpleShape"))),
//     ],
//     "",
//   ),
// ]
