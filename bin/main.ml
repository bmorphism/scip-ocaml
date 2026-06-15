open Base
open Scip_proto.Scip
open Scip_ocaml
module Dir = Bos.OS.Dir

let ( let* ) v f = Option.bind ~f v

let index project_root outfile =
  Fmt.pr "Indexing project at %s@." (Fpath.to_string project_root);
  let files = Scip.find_cm_files project_root in
  let index = Scip.ScipIndex.index project_root files in
  let outpath =
    let p = Fpath.v outfile in
    if Fpath.is_abs p then p else Fpath.(project_root // p)
  in
  let _ = Scip.ScipIndex.serialize index outpath in
  ()
;;

let compare_range (a : int32 list) (b : int32 list) =
  let open Int32 in
  match a, b with
  | a :: _ :: _, b :: _ :: _ when a <> b -> a - b |> to_int_exn
  | _ :: a :: _, _ :: b :: _ when a <> b -> a - b |> to_int_exn
  | _ :: _ :: a :: _, _ :: _ :: b :: _ when a <> b -> a - b |> to_int_exn
  | _ -> 0
;;

let compare_occ a b = compare_range a.range b.range

let snapshot project_root outfile snapshot_dir mode =
  Fmt.pr "  Snapshotting project at: %s@." (Fpath.to_string project_root);
  let _ = index project_root outfile in
  let document_to_snapshot =
    let path = Fpath.(project_root / outfile) in
    let index =
      match Scip.ScipIndex.deserialize path with
      | Some index -> index
      | None ->
        Fmt.epr "Failed to read snapshot: %s@." (Fpath.to_string path);
        assert false
    in
    let with_docs =
      List.filter_map index.documents ~f:(fun document ->
        Scip_proto.Scip.document_set_occurrences
          document
          (List.sort document.occurrences ~compare:compare_occ);
        let* snapshot = Scip.ScipDocument.read document project_root in
        let snapshot = Scip_snapshot.doc_to_string document snapshot in
        Some (document.relative_path, snapshot))
    in
    Map.of_alist_exn (module String) with_docs
  in
  match mode with
  | `Promote ->
    let _ = Bos.OS.Dir.create snapshot_dir in
    Map.iteri document_to_snapshot ~f:(fun ~key ~data ->
      let path = Fpath.(snapshot_dir / key) in
      let _ = Bos.OS.File.write path data in
      ());
    Map.empty (module String)
  | `Diff ->
    Map.filter_mapi document_to_snapshot ~f:(fun ~key ~data ->
      let path = Fpath.(snapshot_dir / key) in
      let existing =
        match Bos.OS.File.read path with
        | Ok existing -> existing
        | _ -> ""
      in
      (* TODO: Could do the diff probably? *)
      if String.(existing <> data) then Some key else None)
  | `Write ->
    Map.iteri document_to_snapshot ~f:(fun ~key ~data -> Fmt.pr "  %s -> %s@." key data);
    Map.empty (module String)
;;

let snapshot_dir root mode =
  let input = Fpath.(root / "input") in
  let output = Fpath.(root / "output") in
  let contents =
    match input |> Dir.contents ~rel:false with
    | Ok contents -> contents
    | _ -> assert false
  in
  let do_snapshot acc project =
    snapshot project "index.scip" output mode
    |> Map.fold ~init:acc ~f:(fun ~key ~data -> Map.add_exn ~key ~data)
  in
  let init = Map.empty (module String) in
  let diffed = List.fold contents ~init ~f:do_snapshot in
  if Map.length diffed > 0
  then (
    Fmt.pr "Snapshot diffed files: %d@." (Map.length diffed);
    Map.iteri diffed ~f:(fun ~key ~data -> Fmt.pr "  %s -> %s@." key data);
    Stdlib.exit 1)
;;

type params =
  { command : string
  ; root : string
  ; outfile : string
  ; snapshot_dir : string
  ; mode : string
  }

(* modern Cmdliner 2.x term, hand-written (replaces dead ppx_deriving_cmdliner) *)
let params_term =
  let command =
    Cmdliner.Arg.(
      required
        (pos 0 (some string) None
           (info [] ~docv:"COMMAND" ~doc:"index | snapshot | snapshot-dir")))
  in
  let root =
    Cmdliner.Arg.(
      value (pos 1 string "." (info [] ~docv:"PROJECT_ROOT" ~doc:"Project root to index")))
  in
  let outfile =
    Cmdliner.Arg.(
      value (pos 2 string "index.scip" (info [] ~docv:"OUTFILE" ~doc:"File to save index")))
  in
  let snapshot_dir =
    Cmdliner.Arg.(
      value
        (opt string "scip-snapshot"
           (info [ "snapshot-dir" ] ~docv:"DIR" ~doc:"Folder to save snapshots to")))
  in
  let mode =
    Cmdliner.Arg.(
      value (opt string "diff" (info [ "mode" ] ~docv:"MODE" ~doc:"promote | diff | write")))
  in
  Cmdliner.Term.(
    const (fun command root outfile snapshot_dir mode ->
      { command; root; outfile; snapshot_dir; mode })
    $ command
    $ root
    $ outfile
    $ snapshot_dir
    $ mode)
;;

let actually_run (params : params) =
  let root =
    match Fpath.of_string params.root with
    | Ok project_root -> project_root
    | _ -> assert false
  in
  let mode =
    match params.mode with
    | "promote" -> `Promote
    | "diff" -> `Diff
    | "write" -> `Write
    | _ -> assert false
  in
  match params.command with
  | "index" -> index root params.outfile
  | "snapshot" ->
    let snapshot_dir = Fpath.(root / params.snapshot_dir) in
    let _ = snapshot root params.outfile snapshot_dir mode in
    ()
  | "snapshot-dir" ->
    let _ = snapshot_dir root mode in
    ()
  | _ -> Fmt.epr "Unknown command: %s@." params.command
;;

let main () =
  let info = Cmdliner.Cmd.info "scip-ocaml" ~doc:"Emit SCIP for OCaml" in
  let term = Cmdliner.Term.(const actually_run $ params_term) in
  let cmd = Cmdliner.Cmd.v info term in
  Stdlib.exit (Cmdliner.Cmd.eval cmd)
;;

let () = main ()
