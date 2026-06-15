(**************************************************************************)
(* Originally copied from:
   https://sourcegraph.com/github.com/ocaml/ocaml/-/blob/typing/tast_iterator.ml *)
(* Adapted for user -- tasty.ml :) *)
(**************************************************************************)

open Asttypes
open Typedtree
open Default
open Scip_proto.Scip
open Scip_mods

let payload_to_str (payload : Parsetree.payload) =
  match payload with
  | Parsetree.PStr structure ->
    List.fold structure ~init:"" ~f:(fun acc str_item ->
      match str_item.pstr_desc with
      (* | Parsetree.Pstr_eval (expr, _) -> acc ^ Fmt.str "%a" Pprintast.expression expr *)
      | Parsetree.Pstr_eval (expr, _) ->
        (match expr.pexp_desc with
         | Pexp_constant { pconst_desc = Pconst_string (str, _, _); _ } -> acc ^ str
         | _ -> acc)
      | _ -> acc)
  | _ -> assert false
;;

let make_documentation ?plaintext type_info =
  let result = [ "```ocaml"; type_info; "```" ] in
  match plaintext with
  | Some text -> result @ [ text ]
  | None -> result
;;

(* External (dependency) references. When a referenced value's definition is not
   in this project's symbol table, it lives in a dependency. Mint a canonical,
   deterministic symbol from the resolved [Path.t]: the same dependency value
   referenced from any project yields the same symbol, so indexes share edges
   through their common dependencies (e.g. every project's [List.map] occurrence
   points at one [stdlib] symbol). The package coordinate is the dependency's
   top module, lowercased — so external symbols are package-distinct from the
   index's own. NOTE: this is not yet identical to the symbol the dependency's
   OWN scip-ocaml index would mint (that scheme keys on file path, not module
   path); it makes the external surface visible and cross-index-consistent,
   which is the precondition for true cross-repo resolution. *)
let symbol_of_path path =
  let rec components acc p =
    match p with
    | Path.Pident id -> Ident.name id :: acc
    | Path.Pdot (p, s) -> components (s :: acc) p
    | Path.Papply (p, _) -> components acc p
    | _ -> acc
  in
  (* a dune-wrapped unit [Foo__Bar] denotes [Foo.Bar]; unwrap on "__" *)
  let unwrap name =
    String.substr_replace_all name ~pattern:"__" ~with_:"." |> String.split ~on:'.'
  in
  match List.concat_map (components [] path) ~f:unwrap with
  | [] -> None
  | head :: _ when String.is_empty head || not (Char.is_uppercase head.[0]) ->
    (* a bare [Pident] whose head is lowercase is a LOCAL binding (let-bound
       value or function parameter), not a dependency reference — the resolved
       path of a genuine external is always module-qualified ([Pdot], head
       Capitalized per OCaml's lexical law). Minting a package from a local
       variable name ([x], [xs], [loc]) is pure noise, so drop it: in-tree
       values are already handled by the location lookup above. *)
    None
  | parts ->
    let pkg_name = String.lowercase (List.hd_exn parts) in
    let n = List.length parts in
    let descriptors =
      List.mapi parts ~f:(fun i name ->
        let suffix = if i = n - 1 then Term else Type in
        make_descriptor ~name ~suffix ())
    in
    Some
      (ScipSymbol.to_string
       @@ Scip_proto.Scip.make_symbol
            ~scheme:"scip-ocaml"
            ~package:(make_package ~manager:"opam" ~name:pkg_name ~version:"." ())
            ~descriptors
            ())
;;

let handle_structure index_lookup document arg_structure =
  (* Rest of the stuff *)
  let relative_path = document.relative_path in
  let _ = Stdlib.Filename.remove_extension relative_path in
  let document = ref document in
  let add_occurence ?documentation (occ : occurrence) =
    let d = !document in
    if Int32.(occ.symbol_roles = SymbolRoles.definition)
    then
      document_set_symbols
        d
        (make_symbol_information ~symbol:occ.symbol ?documentation () :: d.symbols);
    document_set_occurrences d (occ :: d.occurrences)
  in
  let emit_label_reference lid (label : Types.label_description) =
    IndexSymbols.lookup index_lookup label.lbl_loc
    |> Option.iter ~f:(fun symbol ->
         let range = ScipRange.of_loc lid.loc in
         add_occurence @@ make_occurrence ~range ~symbol ())
  in
  let expr sub expr_t =
    let _ =
      match expr_t.exp_desc with
      | Texp_ident (path, lid, value) ->
        let range = ScipRange.of_loc lid.loc in
        (match IndexSymbols.lookup index_lookup value.val_loc with
         | Some symbol ->
           (* in-tree definition *)
           add_occurence (make_occurrence ~range ~symbol ())
         | None ->
           (* external (dependency) reference — resolve via the path *)
           (match symbol_of_path path with
            | Some symbol -> add_occurence (make_occurrence ~range ~symbol ())
            | None -> ()))
      | Texp_record { fields; extended_expression; _ } ->
        let _ = extended_expression in
        Array.iter
          ~f:(function
            | _, Kept _ -> ()
            | label, Overridden (lid, _) -> emit_label_reference lid label)
          fields
      | Texp_field (_, lid, label) -> emit_label_reference lid label
      | _ -> ()
    in
    Default.iter.expr sub expr_t
  in
  let value_binding sub value =
    let pat = value.vb_pat in
    IndexSymbols.lookup index_lookup pat.pat_loc
    |> Option.iter ~f:(fun symbol ->
         let range = ScipRange.of_loc pat.pat_loc in
         let documentation =
           make_documentation
           @@ Fmt.str "%a" Printtyp.type_expr pat.pat_type
         in
         add_occurence ~documentation
         @@ make_occurrence ~range ~symbol ~symbol_roles:SymbolRoles.definition ());
    Default.iter.value_binding sub value
  in
  let module_binding sub module_ =
    let loc = module_.mb_name.loc in
    IndexSymbols.lookup index_lookup loc
    |> Option.iter ~f:(fun symbol ->
         let range = ScipRange.of_loc loc in
         let documentation =
           make_documentation
           @@ Fmt.str "%a" Printtyp.modtype module_.mb_expr.mod_type
         in
         add_occurence ~documentation
         @@ make_occurrence ~range ~symbol ~symbol_roles:SymbolRoles.definition ());
    Default.iter.module_binding sub module_
  in
  let type_declaration this decl_t =
    IndexSymbols.lookup index_lookup decl_t.typ_name.loc
    |> Option.iter ~f:(fun symbol ->
         let range = ScipRange.of_loc decl_t.typ_name.loc in
         let documentation =
           (* make_documentation @@ Fmt.str "%a" Printtyp.type_expr pat.pat_type *)
           make_documentation @@ Fmt.str "%s" (Ident.name decl_t.typ_id)
         in
         add_occurence ~documentation
         @@ make_occurrence ~range ~symbol ~symbol_roles:SymbolRoles.definition ());
    Default.iter.type_declaration this decl_t
  in
  let label_declaration sub label =
    IndexSymbols.lookup index_lookup label.ld_loc
    |> Option.iter ~f:(fun symbol ->
         let attrs = label.ld_attributes in
         let docs =
           List.fold attrs ~init:"" ~f:(fun acc { attr_name; attr_payload; _ } ->
             match attr_name.txt with
             | "ocaml.doc" -> Fmt.str "%s%s\n" acc (payload_to_str attr_payload)
             | _ -> acc)
         in
         let range = ScipRange.of_loc label.ld_name.loc in
         let documentation =
           make_documentation ~plaintext:docs
           @@ Fmt.str
                "%s: %a"
                (Ident.name label.ld_id)
                Printtyp.type_expr
                label.ld_type.ctyp_type
         in
         add_occurence ~documentation
         @@ make_occurrence ~range ~symbol ~symbol_roles:SymbolRoles.definition ());
    Default.iter.label_declaration sub label
  in
  let label_description sub (label_desc : Types.label_description) =
    (* let type_expr = label_desc.lbl_res in *)
    (* let type_str = Fmt.str "%a" Printtyp.type_expr type_expr in *)
    (* let loc = label_desc.lbl_loc in *)
    (* let loc_str = ScipLoc.of_loc loc |> ScipLoc.to_string in *)
    (* IndexSymbols.lookup index_lookup label_desc. *)
    Default.iter.label_description sub label_desc
  in
  let case sub case =
    let loc = case.c_lhs.pat_loc in
    IndexSymbols.lookup index_lookup loc
    |> Option.iter ~f:(fun symbol ->
         let range = ScipRange.of_loc loc in
         add_occurence
         @@ make_occurrence ~range ~symbol ~symbol_roles:SymbolRoles.definition ());
    Default.iter.case sub case
  in
  let iter =
    { Default.iter with
      expr
    ; case
    ; module_binding
    ; type_declaration
    ; value_binding
    ; label_declaration
    ; label_description
    }
  in
  iter.structure iter arg_structure;
  Some !document
;;
