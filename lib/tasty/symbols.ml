open Scip_proto.Scip
open Scip_mods
open Typedtree

type string_to_loc = string Map.M(ScipLoc).t

module SymbolTracker = struct
  (* Is it good or bad to do this kind of thing...
     I'm not super in love with all mutable fields.
     Doesn't feel very "ocaml" *)
  type t =
    { mutable globals : string_to_loc
    ; mutable locals : string_to_loc
    ; mutable local_idx : int
    }

  let init () =
    { globals = Map.empty (module ScipLoc)
    ; locals = Map.empty (module ScipLoc)
    ; local_idx = 0
    }
  ;;

  let get_globals this = this.globals
  let get_locals this = this.locals

  let add_global this loc symbol =
    let loc = ScipLoc.of_loc loc in
    (* TODO: Probably should not let duplicateds happen *)
    match Map.add this.globals ~key:loc ~data:symbol with
    | `Duplicate -> ()
    | `Ok globals -> this.globals <- globals
  ;;

  let add_local this loc =
    (* Compiler/ppx-generated bindings share the ghost [_none_] location, so
       guard against ghost locs and duplicate keys instead of [add_exn]'ing
       (which crashes on ppx-preprocessed sources). *)
    if loc.Location.loc_ghost
    then ()
    else (
      let key = ScipLoc.of_loc loc in
      let idx = this.local_idx in
      match Map.add this.locals ~key ~data:(ScipSymbol.new_local idx) with
      | `Duplicate -> ()
      | `Ok locals ->
        this.locals <- locals;
        this.local_idx <- idx + 1)
  ;;
end

module IterState = struct
  type t =
    { with_descriptor : descriptor -> (unit -> unit) -> unit
    ; get_descriptors : unit -> descriptor list
    }

  let init descriptors =
    (* Manage descriptors *)
    let with_descriptor descriptor f =
      descriptors := descriptor :: !descriptors;
      let result = f () in
      descriptors := List.tl_exn !descriptors;
      result
    in
    let get_descriptors () = !descriptors in
    { with_descriptor; get_descriptors }
  ;;
end

let default_package = Some (make_package ~manager:"opam" ~name:"." ~version:"." ())

let make_symbol_with_descriptor descriptors descriptor =
  let descriptors = descriptor :: descriptors in
  ScipSymbol.to_string
  @@ Scip_proto.Scip.make_symbol
       ~scheme:"scip-ocaml"
       ?package:default_package
       ~descriptors:(List.rev descriptors)
       ()
;;

(* NOTE: descriptors is reversed from the way that you're going to actually
   use them, since that allows you to super easily pop on and off the scope.

   We just reverse it when we make a symbol... maybe that's stupid :) *)
let make_symbol ~descriptors ~name ~suffix ?disambiguator () =
  make_symbol_with_descriptor descriptors
  @@ make_descriptor ~name ~suffix ?disambiguator ()
;;

module PatDesc = struct
  let to_string = function
    | Tpat_any -> "any"
    | Tpat_var _ -> "var"
    | Tpat_alias _ -> "alias"
    | Tpat_constant _ -> "constant"
    | Tpat_tuple _ -> "tuple"
    | Tpat_construct _ -> "construct"
    | Tpat_variant _ -> "variant"
    | Tpat_record _ -> "record"
    | Tpat_array _ -> "array"
    | Tpat_or _ -> "or"
    | Tpat_lazy _ -> "lazy"
    | _ -> "other"
  ;;
end

(*  TODO: Should use this more i think *)
let pattern_name pattern =
  match pattern.pat_desc with
  | Tpat_var (ident, _, _, _, _) -> Some (Ident.name ident)
  | Tpat_constant _ -> None
  | _ -> None
;;

let find_symbols structure state tracker =
  let default_iterator = Default.iter in
  (* Used to generate symbols not that are local.
      Called by the iterator below *)
  let local_value_bind _ value =
    match value.vb_pat.pat_desc with
    | Tpat_var _ -> SymbolTracker.add_local tracker value.vb_pat.pat_loc
    | _ -> ()
  in
  let local_iter = ref { default_iterator with value_binding = local_value_bind } in
  (* Used to generate top level symbol definitions *)
  let value_binding _ value =
    let pattern = value.vb_pat in
    let expr = value.vb_expr in
    let descriptors = IterState.(state.get_descriptors ()) in
    let name =
      match pattern.pat_desc with
      | Tpat_var (ident, _, _, _, _) -> Some (Ident.name ident)
      | _ -> None
    in
    let symbol =
      (* [Typedtree.Method] (a poly-method poly_param) shadows the SCIP
         descriptor suffix [Method], so qualify it. *)
      match expr.exp_desc with
      | Texp_function _ -> Some Scip_proto.Scip.Method
      | Texp_constant _ -> Some Term
      | _ -> Some Term
    in
    let descriptor_scope =
      match name, symbol with
      | Some name, Some suffix ->
        let descriptor = make_descriptor ~name ~suffix () in
        let symbol = make_symbol_with_descriptor descriptors descriptor in
        SymbolTracker.add_global tracker pattern.pat_loc symbol;
        Some descriptor
      | _ -> None
    in
    let register_param pat =
      pattern_name pat
      |> Option.iter ~f:(fun name ->
           let descriptors = IterState.(state.get_descriptors ()) in
           let symbol = make_symbol ~descriptors ~name ~suffix:Parameter () in
           SymbolTracker.add_global tracker pat.pat_loc symbol)
    in
    let param_pat fp =
      (* OCaml 5.2 n-ary functions: each parameter carries either a plain
         pattern or an optional-argument pattern with a default. *)
      match fp.fp_kind with
      | Tparam_pat p -> Some p
      | Tparam_optional_default (p, _, _) -> Some p
    in
    (* TODO: I think this is probably not that good instead, we should probably use something like a new
             iterator, that can go over these and then exists when it's done handling the params *)
    let rec handle_function params body =
      List.iter params ~f:(fun fp ->
        match param_pat fp with
        | Some p -> register_param p
        | None -> ());
      match body with
      | Tfunction_body e ->
        (match e.exp_desc with
         | Texp_function { params; body; _ } -> handle_function params body
         | _ -> ())
      | Tfunction_cases fc ->
        (* The final argument is bound and matched by these cases. *)
        List.iter fc.fc_cases ~f:(fun case ->
          register_param case.c_lhs;
          match case.c_rhs.exp_desc with
          | Texp_function { params; body; _ } -> handle_function params body
          | _ -> ())
    in
    begin
      match expr.exp_desc with
      | Texp_function { params; body; _ } ->
        (* nameless ppx-generated function bindings have no descriptor_scope;
           skip rather than Option.value_exn-crash (qcheck/ppxlib .pp.ml) *)
        (match descriptor_scope with
         | Some descriptor_scope ->
           IterState.(
             state.with_descriptor descriptor_scope
             @@ fun () -> handle_function params body)
         | None -> ())
      | _ -> ()
    end;
    (* TODO: I think we can write this without copying *)
    (* match descriptor_scope with *)
    (* | Some descriptor_scope -> *)
    (*   IterState.( *)
    (*     state.with_descriptor descriptor_scope *)
    (*     @@ fun () -> default_iterator.value_binding sub value) *)
    (* | None -> default_iterator.value_binding sub value *)
    default_iterator.value_binding !local_iter value
  in
  let module_binding this module_ =
    let name = module_.mb_name.txt |> Option.value_exn in
    let descriptors = IterState.(state.get_descriptors ()) in
    let module_descriptor = make_descriptor ~name ~suffix:Type () in
    let symbol = make_symbol_with_descriptor descriptors module_descriptor in
    SymbolTracker.add_global tracker module_.mb_name.loc symbol;
    state.with_descriptor module_descriptor
    @@ fun () -> default_iterator.module_binding this module_
  in
  let case : 'k. Default.iterator -> 'k case -> unit =
   fun this c ->
    (* pat_desc; pat_loc; pat_extra; pat_type; pat_env; pat_attributes; *)
    let _ = c.c_lhs in
    let desc = c.c_lhs.pat_desc in
    let _ = desc in
    let _ = c.c_guard in
    let _ = c.c_rhs in
    default_iterator.case this c
  in
  let type_declaration this type_declaration =
    let name = type_declaration.typ_name.txt in
    let descriptors = IterState.(state.get_descriptors ()) in
    let type_descriptor = make_descriptor ~name ~suffix:Type () in
    let symbol = make_symbol_with_descriptor descriptors type_descriptor in
    SymbolTracker.add_global tracker type_declaration.typ_name.loc symbol;
    IterState.(
      state.with_descriptor type_descriptor
      @@ fun () -> default_iterator.type_declaration this type_declaration)
  in
  let label_declaration this label =
    let descriptors = IterState.(state.get_descriptors ()) in
    let symbol =
      make_symbol ~descriptors ~name:(Ident.name label.ld_id) ~suffix:Term ()
    in
    SymbolTracker.add_global tracker label.ld_loc symbol;
    default_iterator.label_declaration this label
  in
  let label_description sub label_desc =
    default_iterator.label_description sub label_desc
  in
  let expr sub expr = Default.iter.expr sub expr in
  let iter =
    { default_iterator with
      value_binding
    ; module_binding
    ; case
    ; expr
    ; type_declaration
    ; label_declaration
    ; label_description
    }
  in
  (* TODO: I think this may be kind of weird... but it's OK for now. *)
  local_iter := { iter with value_binding = local_value_bind };
  iter.structure iter structure
;;

let traverse document structure =
  Fmt.pr "  Traversing Document: %s@." document.relative_path;
  let relative_path = document.relative_path in
  let relative_path = Stdlib.Filename.remove_extension relative_path in
  let descriptors =
    ref [ make_descriptor ~name:relative_path ~suffix:Namespace () ]
  in
  let state = IterState.init descriptors in
  let tracker = SymbolTracker.init () in
  find_symbols structure state tracker;
  DocumentSymbols.init
    document
    (SymbolTracker.get_globals tracker)
    (SymbolTracker.get_locals tracker)
;;
(***)
(* (* TODO: Create local symbol iterator... just adds to local iterator *) *)
