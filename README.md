# scip-ocaml

The OCaml → [SCIP](https://github.com/sourcegraph/scip) indexer, maintained.

`scip-ocaml` reads dune-produced typed trees (`.cmt`/`.cmti`, via Merlin's
`Tasty`) and emits a [SCIP](https://github.com/sourcegraph/scip) index —
documents, occurrences, `SymbolInformation`, monikers — that the official
`scip` CLI validates and that Sourcegraph-class tooling consumes. It is the
only OCaml→SCIP emitter that exists (SCIP reserves language id `OCaml = 41`).

This is a **maintained fork** of [`tjdevries/scip-ocaml`](https://github.com/tjdevries/scip-ocaml),
whose last upstream commit was 2023-04-26 and which builds only on OCaml 4.14.
Here it is modernized and kept green:

- **OCaml 5.3.0 mainline** is the toolchain (upstream was capped at 4.14 by a
  2022-era opam-monorepo lock; that lock is gone).
- **Three crash classes fixed** (ghost `_none_` locations, duplicate/Packed
  wrapper `.cmt`, nameless ppx `Texp_function` bindings) — see *What changed*.
- **Dead deps replaced**: hand-written Cmdliner 2.x term (the abandoned
  `ppx_deriving_cmdliner` no longer solves on 5.x); unified `pbrt` 4.x protobuf
  codegen (was the split `ocaml-protoc` 2.4 `_pb`/`_pp`/`_types` modules).
- **Validated at scale** on the Rocq prover, the Narya proof assistant, and the
  Stellogen interpreter — see *Illustrations*.

## Illustrations

Four real codebases on OCaml 5.3.0, each chosen to stress a different axis. All
index to completion with `index_exit=0` and zero skipped/crashed documents; all
counts are from the reference `scip` CLI (`scip stats --from index.scip`,
v0.8.1).

| codebase | what it stresses | docs | occurrences | definitions | `index.scip` |
|---|---|---|---:|---:|---:|
| [rocq-prover/rocq](https://github.com/rocq-prover/rocq) | **scale + ppx** | 680 | 245,781 | 57,612 | 21.0 MB |
| [gwaithimirdain/narya](https://github.com/gwaithimirdain/narya) | **OCaml 5.3.0 native** | 238 | 40,962 | 9,439 | 4.93 MB |
| [engboris/stellogen](https://github.com/engboris/stellogen) | **full def/ref walk, small** | 24 | 4,720 | 1,953 | 0.50 MB |
| [plurigrid/place](https://github.com/plurigrid/place) `cct-reading-group` | **OCaml inside a forester forest** | 9 | 67 | 26 | 6.6 KB |

**Rocq** — the theorem prover, built on OCaml 5.3.0 (`./configure
-native-compiler no` + `dune build @check`): 657 `.ml` modules across kernel /
pretyping / engine / interp / plugins / vernac, heavy ppx (only the
`lablgtk3-sourceview3` GUI and `camlzip` bench targets are absent system libs).
The capstone for *no crash at scale*: 657 documents traversed, ~58k definitions,
without a single ghost-location or duplicate-`.cmt` exception (every one of
which would have aborted the unpatched indexer). Sample symbols resolve cleanly:
`kernel/vmvalues.pstring_cat`, `engine/univSubst.pr_universe_subst`,
`interp/smartlocate.smart_global_inductive`. Detail in
[`ROCQ_CAPSTONE.md`](ROCQ_CAPSTONE.md).

**Narya** — Michael Shulman's higher-dimensional / parametric dependent type
checker. It is itself an **OCaml 5.3.0** project, so it is the proof that the
indexer's compiler-libs match a modern producer's `.cmt` format (the
version-lock that governs every `.cmt` read): build Narya on the `scip53`
switch, index with the binary built on the *same* switch, 238 documents clear.
Exercises 5.x Typedtree idioms (n-ary `Texp_function`, `Tfunction_cases`,
3-arg `Tpat_var`) that pre-5.x trees never carry.

**Stellogen** — Boris Eng's interpreter for *stellar resolution* (term
unification with polarities). Small (24 documents) but dense: at ~81
definitions/document and ~197 occurrences/document it is the per-file workout
for the def/ref walk — `unification.ml`, `lsc_ast.ml`, `sgen_ast.ml`,
`sgen_eval.ml` all index, including the `polarity = Pos | Neg | Null` core and
the `exec : marked_constellation -> constellation` evaluator.

**plurigrid/place** — *a forester forest with code in it.* `place` is a
[forester](https://www.jonmsterling.com/forester/) forest: ~4,000 `.tree`
files (TeX-like prose, transcluded and hyperlinked into a navigable web),
`forest.toml`, `forester-mode.el`. Nested inside is a real OCaml dune project,
`localcharts/cct-reading-group` (an applied-category-theory reading group:
`lib/Categories.ml`, `Graph.ml`, `Fin_set.ml`). The correspondence is exact and
is the reason it earns a row: **a SCIP index *is* a forest** — symbols are
trees, monikers are tree addresses, occurrences are transclusions, and
`relationships` are the edges. `scip-ocaml` turns the forest's *code* into the
same kind of addressable, cross-linked graph that forester builds from its
*prose*. Indexing the dune subtree yields a small but clean forest-of-symbols
(9 docs / 67 occ / 26 defs).

For what these four indexes reveal when compared — reference density, function-
vs-value shape, nesting depth, documentation coverage, and the one commonality
SCIP *cannot* see — see [`COMPARISON.md`](COMPARISON.md).

## Build (OCaml 5.3.0 — default)

```sh
opam switch create scip53 5.3.0          # or reuse an existing 5.3.0 switch
opam install --switch scip53 dune base fmt fpath cmdliner bos rresult \
  merlin-lib pbrt
cd scip-ocaml
opam exec --switch scip53 -- dune build  # => _build/default/bin/main.exe (~15 MB)
```

> **`.cmt` version lock.** The indexer's `compiler-libs` must match the OCaml
> version that *produced* the target's `.cmt`. Build the indexer and the target
> on the same 5.3.0 switch.

## Index a target

```sh
cd <target>
opam exec --switch scip53 -- dune build              # produce .cmt/.cmti
/path/to/scip-ocaml/_build/default/bin/main.exe index . index.scip
scip stats --from index.scip                         # verify (official CLI)
```

`OUTFILE` may be relative (resolved under the project root) or absolute. The
patched indexer no longer needs the old `rm -rf _build/install` /
`find -name '*.pp.ml' -delete` workarounds — duplicate, Packed, and
ghost-location nodes are now skipped, not fatal.

## What changed (vs upstream `tjdevries/scip-ocaml`)

Robustness (each was a hard crash upstream; root-caused on Rocq/qcheck/ppxlib):

1. **Ghost `_none_` locations** from ppx/synthetic nodes →
   `SymbolTracker.add_local` guards `loc_ghost` and treats duplicate keys as
   `` `Duplicate -> () `` instead of `Map.add_exn`-crashing
   (`lib/tasty/symbols.ml`).
2. **Nameless ppx `Texp_function` bindings** with no descriptor scope → skipped
   rather than `Option.value_exn`-crashing (`lib/tasty/symbols.ml`).
3. **Duplicate / Packed wrapper `.cmt`** (`NAME__.cmt`, `_build/install`
   mirrors) → `get_symbols`/`of_cmt` return `None` and `IndexSymbols.merge`
   is last-wins (`Map.set`), instead of `failwith` / `add_exn`
   (`lib/scip.ml`, `lib/types/IndexSymbols.ml`).
4. **Malformed / version-mismatched `.cmt`** (a stale artifact from another
   switch left in `_build`) → `Cmt_format.read_cmt` raises `Cmi_format.Error`;
   `CmFile.load_cmt` now catches it and skips the file rather than aborting the
   whole index (`lib/scip.ml`).

Symbol identity:

5. **Project-scoped package coordinate.** Symbols were minted with a hardcoded
   package `opam . .`, giving *every* indexed project the same coordinate —
   two repos with a file at the same relative path defining the same name emit
   byte-identical symbols and collide when indexes are merged. The package
   `name`/`version` are now derived from the target's `dune-project`
   (`(name …)`, `(version …)`), e.g. `scip-ocaml opam narya .`,
   `scip-ocaml opam rocq-prover dev` (`lib/scip.ml`, `lib/tasty/symbols.ml`).

Modernization:

6. **OCaml 5.x / 5.3.0 port** — `lib/tasty/default.ml` rewritten as a thin
   bridge over stock `Tast_iterator`; 5.3 Typedtree deltas (n-ary functions,
   `Tfunction_cases`, arity changes on `Tpat_var`/`Texp_ident`/`Texp_field`,
   `Pconst_string`); `Caml.*` → `Stdlib.*`.
7. **CLI** — hand-written Cmdliner 2.x term replaces the unsatisfiable
   `[@@deriving cmdliner]` (`bin/main.ml`).
8. **Protobuf** — single `pbrt` 4.x `lib/proto/scip.ml{,i}` replaces the split
   `ocaml-protoc` 2.4 generated modules.

## Honest limitations

- **Referentially closed.** A produced index has *zero external surface*: only
  symbols defined within the indexed tree get `SymbolInformation`; references
  into dependencies are not resolved to their defining package. This is
  robustness-complete but **not cross-repo-complete** — no go-to-definition
  across package boundaries. (`lib/scip.ml:199`, `(* TODO: external symbols *)`.)
  Symbols are now project-scoped (the package coordinate is derived from
  `dune-project`, not the old shared `opam . .`), so distinct projects no
  longer collide — but consuming another project's symbols still requires that
  external-symbol resolution, which is not yet implemented.
- **No hover docs / find-implementations parity** with tier-1 indexers
  (`scip-typescript`, `scip-go`, `scip-java`).
- For *editor* navigation within a project, `voodoos/ocaml-index` +
  Merlin/OCaml-LSP is compiler-accurate and handles more node classes — but it
  writes `.ocaml-index`, **not** SCIP. Use `scip-ocaml` when you specifically
  need a `.scip` file for a SCIP pipeline.

## Credits

Original work and the Tasty design: [tjdevries](https://github.com/tjdevries/scip-ocaml).
SCIP and the validating CLI: [Sourcegraph](https://github.com/sourcegraph/scip).
Illustration codebases: Rocq (rocq-prover), Narya (Michael Shulman /
gwaithimirdain), Stellogen (Boris Eng). License: as upstream.
