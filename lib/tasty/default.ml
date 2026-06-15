(**************************************************************************)
(* Modernized for OxCaml / OCaml 5.2.

   The original file was a hand-vendored copy of the compiler's
   [tast_iterator.ml]. OxCaml's Typedtree has diverged substantially
   (jkinds, modes, modalities, unboxed types, the new n-ary
   [Texp_function] with [params]/[body], etc.), so maintaining a full
   hand-written copy is both fragile and unnecessary: OxCaml ships
   [Tast_iterator] in [compiler-libs.common].

   We therefore keep this module's *public surface* (an extended iterator
   record carrying the two custom hooks [label_declaration] and
   [label_description] that the rest of scip-ocaml relies on) but
   implement traversal by delegating to the stock [Tast_iterator]. The
   bridge [to_stock] routes the overlapping callbacks back into our
   extended iterator, preserving open recursion through user overrides. *)
(**************************************************************************)

open Typedtree

type iterator =
  { expr : iterator -> expression -> unit
  ; value_binding : iterator -> value_binding -> unit
  ; module_binding : iterator -> module_binding -> unit
  ; type_declaration : iterator -> type_declaration -> unit
  ; type_kind : iterator -> type_kind -> unit
  ; structure : iterator -> structure -> unit
  ; case : 'k. iterator -> 'k case -> unit
  ; (* Hooks not present in the stock iterator, fired manually below. *)
    label_declaration : iterator -> label_declaration -> unit
  ; label_description : iterator -> Types.label_description -> unit
  }

(* A stock [Tast_iterator.iterator] whose overlapping callbacks delegate
   back to [sub], so that the compiler's traversal threads through any
   overrides installed on our extended iterator. *)
let to_stock (sub : iterator) : Tast_iterator.iterator =
  { Tast_iterator.default_iterator with
    expr = (fun _ e -> sub.expr sub e)
  ; value_binding = (fun _ vb -> sub.value_binding sub vb)
  ; module_binding = (fun _ mb -> sub.module_binding sub mb)
  ; type_declaration = (fun _ td -> sub.type_declaration sub td)
  ; type_kind = (fun _ tk -> sub.type_kind sub tk)
  ; structure = (fun _ s -> sub.structure sub s)
  ; case = (fun _ c -> sub.case sub c)
  }

(* Each default performs exactly one level using the *stock* default
   implementation, with child dispatch routed through [to_stock sub]. *)

let expr sub e =
  (match e.exp_desc with
   | Texp_record { fields; _ } ->
     Array.iter fields ~f:(fun (label, _) -> sub.label_description sub label)
   | _ -> ());
  Tast_iterator.default_iterator.expr (to_stock sub) e
;;

let value_binding sub vb =
  Tast_iterator.default_iterator.value_binding (to_stock sub) vb
;;

let module_binding sub mb =
  Tast_iterator.default_iterator.module_binding (to_stock sub) mb
;;

let type_declaration sub td =
  Tast_iterator.default_iterator.type_declaration (to_stock sub) td
;;

let type_kind sub tk =
  (match tk with
   | Ttype_record lbls ->
     List.iter lbls ~f:(fun ld -> sub.label_declaration sub ld)
   | Ttype_variant cds ->
     List.iter cds ~f:(fun cd ->
       match cd.cd_args with
       | Cstr_record lbls -> List.iter lbls ~f:(fun ld -> sub.label_declaration sub ld)
       | Cstr_tuple _ -> ())
   | Ttype_abstract | Ttype_open -> ());
  Tast_iterator.default_iterator.type_kind (to_stock sub) tk
;;

let structure sub s = Tast_iterator.default_iterator.structure (to_stock sub) s

let case : 'k. iterator -> 'k case -> unit =
 fun sub c -> Tast_iterator.default_iterator.case (to_stock sub) c
;;

(* Leaf hooks: defaults are no-ops; the stock traversal already visits the
   underlying core_type / record expressions. *)
let label_declaration _sub _ld = ()
let label_description _sub _desc = ()

let iter =
  { expr
  ; value_binding
  ; module_binding
  ; type_declaration
  ; type_kind
  ; structure
  ; case
  ; label_declaration
  ; label_description
  }
;;
