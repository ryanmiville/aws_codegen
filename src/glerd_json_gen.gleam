// // this file was generated via glerd_json

// import gleam/dict
// import gleam/dynamic
// import gleam/json
// import gleam/list

// import aws_codegen

// pub fn simple_shape_json_encode(x: aws_codegen.SimpleShape) {
//   json.object([
//     #("type_", json.string(x.type_)),
//     #(
//       "mixins",
//       json.nullable(
//         x.mixins,
//         json.array(
//           x__just_type__,
//           json.object([#("target", json.string(x__just_type__.target))]),
//         ),
//       ),
//     ),
//     #("version", json.nullable(x.version, json.string)),
//     #(
//       "resources",
//       json.nullable(
//         x.resources,
//         json.array(
//           x__just_type__,
//           json.object([#("target", json.string(x__just_type__.target))]),
//         ),
//       ),
//     ),
//     #(
//       "errors",
//       json.nullable(
//         x.errors,
//         json.array(
//           x__just_type__,
//           json.object([#("target", json.string(x__just_type__.target))]),
//         ),
//       ),
//     ),
//     #(
//       "traits",
//       json.nullable(
//         x.traits,
//         json.object(
//           x__just_type__
//           |> dict.to_list
//           |> list.map(fn(x) { #(x.0, json.string(x.1)) }),
//         ),
//       ),
//     ),
//     #(
//       "rename",
//       json.nullable(
//         x.rename,
//         json.object(
//           x__just_type__
//           |> dict.to_list
//           |> list.map(fn(x) { #(x.0, json.string(x.1)) }),
//         ),
//       ),
//     ),
//     #(
//       "identifiers",
//       json.nullable(
//         x.identifiers,
//         json.object(
//           x__just_type__
//           |> dict.to_list
//           |> list.map(fn(x) {
//             #(
//               x.0,
//               json.object([#("target", json.string(x__just_type__.target))])(
//                 x.1,
//               ),
//             )
//           }),
//         ),
//       ),
//     ),
//     #(
//       "properties",
//       json.nullable(
//         x.properties,
//         json.object(
//           x__just_type__
//           |> dict.to_list
//           |> list.map(fn(x) {
//             #(
//               x.0,
//               json.object([#("target", json.string(x__just_type__.target))])(
//                 x.1,
//               ),
//             )
//           }),
//         ),
//       ),
//     ),
//     #(
//       "create",
//       json.nullable(
//         x.create,
//         json.object([#("target", json.string(x__just_type__.target))]),
//       ),
//     ),
//     #(
//       "put",
//       json.nullable(
//         x.put,
//         json.object([#("target", json.string(x__just_type__.target))]),
//       ),
//     ),
//     #(
//       "read",
//       json.nullable(
//         x.read,
//         json.object([#("target", json.string(x__just_type__.target))]),
//       ),
//     ),
//     #(
//       "update",
//       json.nullable(
//         x.update,
//         json.object([#("target", json.string(x__just_type__.target))]),
//       ),
//     ),
//     #(
//       "delete",
//       json.nullable(
//         x.delete,
//         json.object([#("target", json.string(x__just_type__.target))]),
//       ),
//     ),
//     #(
//       "list",
//       json.nullable(
//         x.list,
//         json.object([#("target", json.string(x__just_type__.target))]),
//       ),
//     ),
//     #(
//       "operations",
//       json.nullable(
//         x.operations,
//         json.array(
//           x__just_type__,
//           json.object([#("target", json.string(x__just_type__.target))]),
//         ),
//       ),
//     ),
//     #(
//       "collection_operations",
//       json.nullable(
//         x.collection_operations,
//         json.array(
//           x__just_type__,
//           json.object([#("target", json.string(x__just_type__.target))]),
//         ),
//       ),
//     ),
//   ])
//   |> json.to_string
// }

// pub fn simple_shape_json_decode(s: String) {
//   dynamic.decode17(
//     aws_codegen.SimpleShape,
//     dynamic.field("type_", dynamic.string),
//     dynamic.field(
//       "mixins",
//       dynamic.optional(
//         dynamic.list(dynamic.decode1(
//           aws_codegen.Reference,
//           dynamic.field("target", dynamic.string),
//         )),
//       ),
//     ),
//     dynamic.field("version", dynamic.optional(dynamic.string)),
//     dynamic.field(
//       "resources",
//       dynamic.optional(
//         dynamic.list(dynamic.decode1(
//           aws_codegen.Reference,
//           dynamic.field("target", dynamic.string),
//         )),
//       ),
//     ),
//     dynamic.field(
//       "errors",
//       dynamic.optional(
//         dynamic.list(dynamic.decode1(
//           aws_codegen.Reference,
//           dynamic.field("target", dynamic.string),
//         )),
//       ),
//     ),
//     dynamic.field(
//       "traits",
//       dynamic.optional(dynamic.dict(dynamic.string, dynamic.string)),
//     ),
//     dynamic.field(
//       "rename",
//       dynamic.optional(dynamic.dict(dynamic.string, dynamic.string)),
//     ),
//     dynamic.field(
//       "identifiers",
//       dynamic.optional(dynamic.dict(
//         dynamic.string,
//         dynamic.decode1(
//           aws_codegen.Reference,
//           dynamic.field("target", dynamic.string),
//         ),
//       )),
//     ),
//     dynamic.field(
//       "properties",
//       dynamic.optional(dynamic.dict(
//         dynamic.string,
//         dynamic.decode1(
//           aws_codegen.Reference,
//           dynamic.field("target", dynamic.string),
//         ),
//       )),
//     ),
//     dynamic.field(
//       "create",
//       dynamic.optional(dynamic.decode1(
//         aws_codegen.Reference,
//         dynamic.field("target", dynamic.string),
//       )),
//     ),
//     dynamic.field(
//       "put",
//       dynamic.optional(dynamic.decode1(
//         aws_codegen.Reference,
//         dynamic.field("target", dynamic.string),
//       )),
//     ),
//     dynamic.field(
//       "read",
//       dynamic.optional(dynamic.decode1(
//         aws_codegen.Reference,
//         dynamic.field("target", dynamic.string),
//       )),
//     ),
//     dynamic.field(
//       "update",
//       dynamic.optional(dynamic.decode1(
//         aws_codegen.Reference,
//         dynamic.field("target", dynamic.string),
//       )),
//     ),
//     dynamic.field(
//       "delete",
//       dynamic.optional(dynamic.decode1(
//         aws_codegen.Reference,
//         dynamic.field("target", dynamic.string),
//       )),
//     ),
//     dynamic.field(
//       "list",
//       dynamic.optional(dynamic.decode1(
//         aws_codegen.Reference,
//         dynamic.field("target", dynamic.string),
//       )),
//     ),
//     dynamic.field(
//       "operations",
//       dynamic.optional(
//         dynamic.list(dynamic.decode1(
//           aws_codegen.Reference,
//           dynamic.field("target", dynamic.string),
//         )),
//       ),
//     ),
//     dynamic.field(
//       "collection_operations",
//       dynamic.optional(
//         dynamic.list(dynamic.decode1(
//           aws_codegen.Reference,
//           dynamic.field("target", dynamic.string),
//         )),
//       ),
//     ),
//   )
//   |> json.decode(s, _)
// }

// pub fn reference_json_encode(x: aws_codegen.Reference) {
//   json.object([#("target", json.string(x.target))])
//   |> json.to_string
// }

// pub fn reference_json_decode(s: String) {
//   dynamic.decode1(
//     aws_codegen.Reference,
//     dynamic.field("target", dynamic.string),
//   )
//   |> json.decode(s, _)
// }

// pub fn member_json_encode(x: aws_codegen.Member) {
//   json.object([
//     #("target", json.string(x.target)),
//     #(
//       "traits",
//       json.nullable(
//         x.traits,
//         json.object(
//           x__just_type__
//           |> dict.to_list
//           |> list.map(fn(x) { #(x.0, json.string(x.1)) }),
//         ),
//       ),
//     ),
//   ])
//   |> json.to_string
// }

// pub fn member_json_decode(s: String) {
//   dynamic.decode2(
//     aws_codegen.Member,
//     dynamic.field("target", dynamic.string),
//     dynamic.field(
//       "traits",
//       dynamic.optional(dynamic.dict(dynamic.string, dynamic.string)),
//     ),
//   )
//   |> json.decode(s, _)
// }

// pub fn service_json_encode(x: aws_codegen.Service) {
//   json.object([
//     #("smithy", json.string(x.smithy)),
//     #(
//       "shapes",
//       json.object(
//         x.shapes
//         |> dict.to_list
//         |> list.map(fn(x) {
//           #(
//             x.0,
//             json.object([
//               #("type_", json.string(x__just_type__.type_)),
//               #(
//                 "mixins",
//                 json.nullable(
//                   x__just_type__.mixins,
//                   json.array(
//                     x__just_type__,
//                     json.object([
//                       #("target", json.string(x__just_type__.target)),
//                     ]),
//                   ),
//                 ),
//               ),
//               #("version", json.nullable(x__just_type__.version, json.string)),
//               #(
//                 "resources",
//                 json.nullable(
//                   x__just_type__.resources,
//                   json.array(
//                     x__just_type__,
//                     json.object([
//                       #("target", json.string(x__just_type__.target)),
//                     ]),
//                   ),
//                 ),
//               ),
//               #(
//                 "errors",
//                 json.nullable(
//                   x__just_type__.errors,
//                   json.array(
//                     x__just_type__,
//                     json.object([
//                       #("target", json.string(x__just_type__.target)),
//                     ]),
//                   ),
//                 ),
//               ),
//               #(
//                 "traits",
//                 json.nullable(
//                   x__just_type__.traits,
//                   json.object(
//                     x__just_type__
//                     |> dict.to_list
//                     |> list.map(fn(x) { #(x.0, json.string(x.1)) }),
//                   ),
//                 ),
//               ),
//               #(
//                 "rename",
//                 json.nullable(
//                   x__just_type__.rename,
//                   json.object(
//                     x__just_type__
//                     |> dict.to_list
//                     |> list.map(fn(x) { #(x.0, json.string(x.1)) }),
//                   ),
//                 ),
//               ),
//               #(
//                 "identifiers",
//                 json.nullable(
//                   x__just_type__.identifiers,
//                   json.object(
//                     x__just_type__
//                     |> dict.to_list
//                     |> list.map(fn(x) {
//                       #(
//                         x.0,
//                         json.object([
//                           #("target", json.string(x__just_type__.target)),
//                         ])(x.1),
//                       )
//                     }),
//                   ),
//                 ),
//               ),
//               #(
//                 "properties",
//                 json.nullable(
//                   x__just_type__.properties,
//                   json.object(
//                     x__just_type__
//                     |> dict.to_list
//                     |> list.map(fn(x) {
//                       #(
//                         x.0,
//                         json.object([
//                           #("target", json.string(x__just_type__.target)),
//                         ])(x.1),
//                       )
//                     }),
//                   ),
//                 ),
//               ),
//               #(
//                 "create",
//                 json.nullable(
//                   x__just_type__.create,
//                   json.object([#("target", json.string(x__just_type__.target))]),
//                 ),
//               ),
//               #(
//                 "put",
//                 json.nullable(
//                   x__just_type__.put,
//                   json.object([#("target", json.string(x__just_type__.target))]),
//                 ),
//               ),
//               #(
//                 "read",
//                 json.nullable(
//                   x__just_type__.read,
//                   json.object([#("target", json.string(x__just_type__.target))]),
//                 ),
//               ),
//               #(
//                 "update",
//                 json.nullable(
//                   x__just_type__.update,
//                   json.object([#("target", json.string(x__just_type__.target))]),
//                 ),
//               ),
//               #(
//                 "delete",
//                 json.nullable(
//                   x__just_type__.delete,
//                   json.object([#("target", json.string(x__just_type__.target))]),
//                 ),
//               ),
//               #(
//                 "list",
//                 json.nullable(
//                   x__just_type__.list,
//                   json.object([#("target", json.string(x__just_type__.target))]),
//                 ),
//               ),
//               #(
//                 "operations",
//                 json.nullable(
//                   x__just_type__.operations,
//                   json.array(
//                     x__just_type__,
//                     json.object([
//                       #("target", json.string(x__just_type__.target)),
//                     ]),
//                   ),
//                 ),
//               ),
//               #(
//                 "collection_operations",
//                 json.nullable(
//                   x__just_type__.collection_operations,
//                   json.array(
//                     x__just_type__,
//                     json.object([
//                       #("target", json.string(x__just_type__.target)),
//                     ]),
//                   ),
//                 ),
//               ),
//             ])(x.1),
//           )
//         }),
//       ),
//     ),
//   ])
//   |> json.to_string
// }

// pub fn service_json_decode(s: String) {
//   dynamic.decode2(
//     aws_codegen.Service,
//     dynamic.field("smithy", dynamic.string),
//     dynamic.field(
//       "shapes",
//       dynamic.dict(
//         dynamic.string,
//         dynamic.decode17(
//           aws_codegen.SimpleShape,
//           dynamic.field("type_", dynamic.string),
//           dynamic.field(
//             "mixins",
//             dynamic.optional(
//               dynamic.list(dynamic.decode1(
//                 aws_codegen.Reference,
//                 dynamic.field("target", dynamic.string),
//               )),
//             ),
//           ),
//           dynamic.field("version", dynamic.optional(dynamic.string)),
//           dynamic.field(
//             "resources",
//             dynamic.optional(
//               dynamic.list(dynamic.decode1(
//                 aws_codegen.Reference,
//                 dynamic.field("target", dynamic.string),
//               )),
//             ),
//           ),
//           dynamic.field(
//             "errors",
//             dynamic.optional(
//               dynamic.list(dynamic.decode1(
//                 aws_codegen.Reference,
//                 dynamic.field("target", dynamic.string),
//               )),
//             ),
//           ),
//           dynamic.field(
//             "traits",
//             dynamic.optional(dynamic.dict(dynamic.string, dynamic.string)),
//           ),
//           dynamic.field(
//             "rename",
//             dynamic.optional(dynamic.dict(dynamic.string, dynamic.string)),
//           ),
//           dynamic.field(
//             "identifiers",
//             dynamic.optional(dynamic.dict(
//               dynamic.string,
//               dynamic.decode1(
//                 aws_codegen.Reference,
//                 dynamic.field("target", dynamic.string),
//               ),
//             )),
//           ),
//           dynamic.field(
//             "properties",
//             dynamic.optional(dynamic.dict(
//               dynamic.string,
//               dynamic.decode1(
//                 aws_codegen.Reference,
//                 dynamic.field("target", dynamic.string),
//               ),
//             )),
//           ),
//           dynamic.field(
//             "create",
//             dynamic.optional(dynamic.decode1(
//               aws_codegen.Reference,
//               dynamic.field("target", dynamic.string),
//             )),
//           ),
//           dynamic.field(
//             "put",
//             dynamic.optional(dynamic.decode1(
//               aws_codegen.Reference,
//               dynamic.field("target", dynamic.string),
//             )),
//           ),
//           dynamic.field(
//             "read",
//             dynamic.optional(dynamic.decode1(
//               aws_codegen.Reference,
//               dynamic.field("target", dynamic.string),
//             )),
//           ),
//           dynamic.field(
//             "update",
//             dynamic.optional(dynamic.decode1(
//               aws_codegen.Reference,
//               dynamic.field("target", dynamic.string),
//             )),
//           ),
//           dynamic.field(
//             "delete",
//             dynamic.optional(dynamic.decode1(
//               aws_codegen.Reference,
//               dynamic.field("target", dynamic.string),
//             )),
//           ),
//           dynamic.field(
//             "list",
//             dynamic.optional(dynamic.decode1(
//               aws_codegen.Reference,
//               dynamic.field("target", dynamic.string),
//             )),
//           ),
//           dynamic.field(
//             "operations",
//             dynamic.optional(
//               dynamic.list(dynamic.decode1(
//                 aws_codegen.Reference,
//                 dynamic.field("target", dynamic.string),
//               )),
//             ),
//           ),
//           dynamic.field(
//             "collection_operations",
//             dynamic.optional(
//               dynamic.list(dynamic.decode1(
//                 aws_codegen.Reference,
//                 dynamic.field("target", dynamic.string),
//               )),
//             ),
//           ),
//         ),
//       ),
//     ),
//   )
//   |> json.decode(s, _)
// }
