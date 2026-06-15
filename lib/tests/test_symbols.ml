(* Build with `ocamlbuild -pkg alcotest simple.byte` *)

open Scip_proto.Scip
open Scip_mods

(* This can let us get a parse tree for this *)
(* let somethin = Lexing.from_string "let x = 5" |> Parse.expression *)
(* module TestableSymbol : Alcotest.TESTABLE = struct *)
(*   type t = Scip_types.symbol *)
(*   let pp = Scip_pp.pp_symbol *)
(*   let equal a b = a = b *)
(* end *)

(* pbrt 4.1 records track field *presence*, so structural [=] distinguishes an
   absent field from one explicitly set to its proto3 default (e.g. an empty
   [disambiguator]). Compare by encoded protobuf bytes instead, which is the
   intended semantic equality (proto3 omits default-valued fields on the wire). *)
let symbol_eq a b =
  let enc s =
    let e = Pbrt.Encoder.create () in
    encode_pb_symbol s e;
    Pbrt.Encoder.to_string e
  in
  String.equal (enc a) (enc b)
;;

let testable_symbol = Alcotest.testable pp_symbol symbol_eq

let test_local_symbol () =
  Alcotest.(check string) "same string" "local 1" (ScipSymbol.new_local 1)
;;

let pkg manager name version = make_package ~manager ~name ~version ()

let sym scheme manager name version descriptors =
  let package = pkg manager name version in
  make_symbol ~scheme ~package ~descriptors ()
;;

let test_simple_scheme () =
  let expected =
    sym "a" "b" "c" "d" [ make_descriptor ~name:"term" ~suffix:Term () ]
  in
  Alcotest.(check testable_symbol)
    "simple symbol"
    expected
    (ScipSymbol.of_string "a b c d term." |> Result.get_ok)
;;

let test_namespaces_symbol () =
  let symbol = "scip-ocaml opam merlin 14.0 lib/Something#term." in
  let expected =
    sym
      "scip-ocaml"
      "opam"
      "merlin"
      "14.0"
      [ make_descriptor ~name:"lib" ~suffix:Namespace ()
      ; make_descriptor ~name:"Something" ~suffix:Type ()
      ; make_descriptor ~name:"term" ~suffix:Term ()
      ]
  in
  Alcotest.(check testable_symbol)
    "namespaced symbol"
    expected
    (ScipSymbol.of_string symbol |> Result.get_ok)
;;

let test_roundtrip () =
  let symbols =
    [ "scip-ocaml opam merlin 14.0 lib/Something#term."
    ; "lsif-java maven package 1.0.0 java/io/File#Entry.method(+1).(param)[TypeParam]"
    ; "rust-analyzer cargo std 1.0.0 macros/println!"
    ; "a b c d `e f`."
    ]
  in
  Alcotest.(check (list string))
    "round trip"
    symbols
    (List.map
       (fun s -> ScipSymbol.of_string s |> Result.get_ok |> ScipSymbol.to_string)
       symbols)
;;

(* Run it *)
let () =
  let open Alcotest in
  run
    "Scip_symbol"
    [ ( "symbols"
      , [ test_case "local symbol" `Quick test_local_symbol
        ; test_case "parses simple" `Quick test_simple_scheme
        ; test_case "parses namespaced" `Quick test_namespaces_symbol
        ; test_case "round trip" `Quick test_roundtrip
        ] )
    ]
;;
