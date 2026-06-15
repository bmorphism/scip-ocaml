let rec path_to_string (path : Path.t) =
  let p =
    match path with
    | Path.Pident ident -> Ident.name ident
    | Path.Pdot (left, dotted) -> Fmt.str "(dotted) %s.%s" (path_to_string left) dotted
    | Path.Papply (_, _) -> "Papply"
    | Path.Pextra_ty (left, _) -> path_to_string left
  in
  p
;;

let print_long_ident ident = Fmt.str "%a@." Pprintast.longident ident

let print_type_expr (type_expr : Types.type_expr) =
  (* On mainline OCaml 5.3 [Printtyp.type_expr] is already a
     [Format_doc.format_printer] (a plain [Format.formatter] printer), so it
     feeds [Fmt.str "%a"] directly; the OxCaml branch needed
     [Format_doc.compat] because there it was a [Format_doc.printer]. *)
  Fmt.str "%a" Printtyp.type_expr type_expr
;;
