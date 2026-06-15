# Capstone: indexing Rocq (rocq-prover/rocq) with patched scip-ocaml

Date: 2026-06-15  VM: morphvm_n061jz9z  Switch: scip414 (OCaml 4.14.1)
Indexer commit: cf1833d (master) + one build-config line (lib/dune: add )

## Outcome
- Target: rocq-prover/rocq (shallow clone), built with  + 
  under switch scip414. 665 .cmt produced (kernel/plugins/vernac/pretyping/engine/...);
  only lablgtk3 GUI binary + camlzip bench tooling don't link (irrelevant to indexing).
- Indexer ran to completion WITHOUT CRASHING on Rocq's full scale + ppx.
  665 documents traversed, INDEX_EXIT=0, zero skip/exception log lines.
- index.scip = 28,027,264 bytes.

## scip v0.8.1 stats (reference CLI)
- documents:   688  (665 .ml + .mli)
- occurrences: 287,133
- definitions: 99,515

## Sample symbols
- kernel/vmvalues:  pstring_compare, pstring_cat, pstring_sub
- engine/univSubst: pr_universe_subst, nf_evars_and_universes_opt_subst
- interp/smartlocate: smart_global_constructor, smart_global_inductive

## Rebuild notes (switch had been partially stripped)
Reinstalled into scip414: zarith 1.14, angstrom 0.16.1, merlin-lib 4.19-414,
ppx_deriving_cmdliner (+core deps), fpath, bos, rresult, ocaml-protoc PINNED to 2.4
(lock pins 2.4; the  single-dash codegen flag requires it). Added 
to lib/dune (newer bos 0.3.0 no longer re-exports it). camlzip for Rocq's @check.
