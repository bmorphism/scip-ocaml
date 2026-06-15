# Capstone: indexing Rocq (rocq-prover/rocq) with scip-ocaml on OCaml 5.3.0

Date: 2026-06-15  Switch: scip53 (OCaml 5.3.0)
Indexer: the 5.3.0 build (`scip-ocaml` master, `main.exe` ~15 MB).

## Build the target
Rocq HEAD (shallow clone) on the same 5.3.0 switch as the indexer (the `.cmt`
version lock), typecheck-only so the GUI/bench link steps never run:

    opam install -y --switch scip53 zarith
    eval "$(opam env --switch=scip53 --set-switch)"
    cd rocq && ./configure -prefix "$PWD/_install" -native-compiler no
    dune build @check          # 657 .cmt produced

Only `lablgtk3-sourceview3` (RocqIDE GUI) and `camlzip` (`dev/bench`) fail to
resolve — absent system libs, irrelevant to indexing.

## Index
    scip-ocaml/_build/default/bin/main.exe index . index.scip

- 657 documents traversed, `index_exit=0`, zero couldn't/skip lines.
- `index.scip` = 21,022,183 bytes.

## scip v0.8.1 stats (reference CLI)
- documents:   680  (657 .ml + .mli)
- occurrences: 245,781
- definitions: 57,612

## Sample symbols
- kernel/vmvalues:  pstring_compare, pstring_cat, pstring_sub
- engine/univSubst: pr_universe_subst, nf_evars_and_universes_opt_subst
- interp/smartlocate: smart_global_constructor, smart_global_inductive

## Notes
- `lib/dune` carries `unix` explicitly (`Unix.realpath`; bos 0.3.0 no longer
  re-exports it).
- The indexer ran to completion on Rocq's full scale + ppx without a single
  ghost-location, duplicate-`.cmt`, malformed-`.cmt`, or nameless-`Texp_function`
  exception — the four crash classes fixed in this fork, each of which aborted
  the unpatched indexer.
- Symbols are project-scoped: Rocq's carry `scip-ocaml opam rocq-prover dev`
  (name + version read from its `dune-project`), not the old shared `opam . .`.
