# Capstone: indexing Rocq (rocq-prover/rocq) with patched scip-ocaml

Date: 2026-06-15  VM: morphvm_n061jz9z  Switch: scip414 (OCaml 4.14.1)
Indexer commit: cf1833d (master) + one build-config line (lib/dune: add `unix`,
needed by `Unix.realpath` since bos 0.3.0 stopped re-exporting it)

## Outcome
- Target: rocq-prover/rocq (shallow clone), built with `dune build`
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
(lock pins 2.4; the single-dash codegen flag the bundled proto was generated with
requires it). Added `unix` to lib/dune (newer bos 0.3.0 no longer re-exports it).
camlzip for Rocq's @check.

## Latest-OCaml cross-run (OCaml 5.3.0)

Date: 2026-06-15  Local (M-series)  Switch: scip53 (OCaml 5.3.0)
Indexer: the 5.3.0 build (`scip-ocaml-53` master, main.exe ~15 MB).

- Rocq (rocq-prover/rocq HEAD, shallow clone) built on scip53 via
  `./configure -prefix _install -native-compiler no` + `dune build @check`.
  657 .cmt produced; only `lablgtk3-sourceview3` (RocqIDE GUI) and `camlzip`
  (`dev/bench`) targets fail to resolve (absent system libs) — identical scope
  to the 4.14.1 run, which dropped the same two.
- Indexer ran to completion: 657 documents, index_exit=0, zero couldn't/skip
  lines. index.scip = 21,022,183 bytes.

### scip v0.8.1 stats
- documents:   680
- occurrences: 245,781
- definitions: 57,612

### Cross-version difference (measured, not assigned)
Against the 4.14.1 run (688 / 287,133 / 99,515): occurrences −14%, but
definitions −42%. Same prover, same day, ~same module set (657 vs 665) ⇒ the
gap is in the indexer codepath, not the source. The 5.x Typedtree bridge
(rewritten over stock `Tast_iterator`) emits fewer parameter/local definitions
across OCaml 5.x's n-ary-function representation (`Texp_function {params;body}`
+ `Tfunction_cases`) than the 4.14 walk. Both runs complete clean; reconciling
the parameter-definition emission across the two codepaths is the open item.
