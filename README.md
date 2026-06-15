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

- **OCaml 5.3.0 mainline** is the default toolchain (was capped at 4.14 by a
  2022-era opam-monorepo lock). The 4.14 recipe still works for legacy `.cmt`.
- **Three crash classes fixed** (ghost `_none_` locations, duplicate/Packed
  wrapper `.cmt`, nameless ppx `Texp_function` bindings) — see *What changed*.
- **Dead deps replaced**: hand-written Cmdliner 2.x term (the abandoned
  `ppx_deriving_cmdliner` no longer solves on 5.x); unified `pbrt` 4.x protobuf
  codegen (was the split `ocaml-protoc` 2.4 `_pb`/`_pp`/`_types` modules).
- **Validated at scale** on the Rocq prover, the Narya proof assistant, and the
  Stellogen interpreter — see *Illustrations*.

## Illustrations

Three real codebases, each chosen to stress a different axis. All index to
completion with `INDEX_EXIT=0` and zero skipped/crashed documents; all counts
are from the reference `scip` CLI (`scip stats --from index.scip`, v0.8.1).

| codebase | what it stresses | switch | docs | occurrences | definitions | `index.scip` |
|---|---|---|---|---:|---:|---:|
| [rocq-prover/rocq](https://github.com/rocq-prover/rocq) | **scale + ppx** | 4.14.1 | 688 | 287,133 | 99,515 | 28.0 MB |
| [gwaithimirdain/narya](https://github.com/gwaithimirdain/narya) | **OCaml 5.3.0 native** | 5.3.0 | 238 | 40,962 | 9,439 | 4.93 MB |
| [engboris/stellogen](https://github.com/engboris/stellogen) | **full def/ref walk, small** | 5.3.0 | 24 | 5,854 | 2,596 | 0.54 MB |

**Rocq** — the theorem prover, 665 `.ml` modules across kernel / pretyping /
engine / interp / plugins / vernac, heavy ppx. The capstone for *no crash at
scale*: ~100k definitions traversed without a single ghost-location or
duplicate-`.cmt` exception (every one of which would have aborted the
unpatched indexer). Sample symbols resolve cleanly:
`kernel/vmvalues.pstring_cat`, `engine/univSubst.pr_universe_subst`,
`interp/smartlocate.smart_global_inductive`. Detail in
[`ROCQ_CAPSTONE.md`](ROCQ_CAPSTONE.md).

**Narya** — Michael Shulman's higher-dimensional / parametric dependent type
checker. It is itself an **OCaml 5.3.0** project, so it is the proof that the
indexer's compiler-libs match a modern producer's `.cmt` format (the
version-lock that governs every `.cmt` read): build Narya on the `scip53`
switch, index with the binary built on the *same* switch, 238 documents clear.
Exercises 5.x Typedtree idioms (n-ary `Texp_function`, `Tfunction_cases`,
3-arg `Tpat_var`) that the 4.14 codepaths never see.

**Stellogen** — Boris Eng's interpreter for *stellar resolution* (term
unification with polarities). Small (24 documents) but dense: at 108
definitions/document and 243 occurrences/document it is the per-file workout
for the def/ref walk — `unification.ml`, `lsc_ast.ml`, `sgen_ast.ml`,
`sgen_eval.ml` all index, including the `polarity = Pos | Neg | Null` core and
the `exec : marked_constellation -> constellation` evaluator.

## Build (OCaml 5.3.0 — default)

```sh
opam switch create scip53 5.3.0          # or reuse an existing 5.3.0 switch
opam install --switch scip53 dune base fmt fpath cmdliner bos rresult \
  merlin-lib pbrt
cd scip-ocaml
opam exec --switch scip53 -- dune build  # => _build/default/bin/main.exe (~15 MB)
```

The legacy **4.14.1** path (for indexing `.cmt` produced by a 4.14 compiler,
e.g. Rocq) is unchanged and documented in
[`ROCQ_CAPSTONE.md`](ROCQ_CAPSTONE.md): build from `scip_ocaml.opam.locked`
with `menhir.20211230` and `ocaml-protoc` pinned to 2.4.

> **`.cmt` version lock.** The indexer's `compiler-libs` must match the OCaml
> version that *produced* the target's `.cmt`. Build the indexer and the target
> on the same switch (5.3.0 ↔ 5.3.0, 4.14.1 ↔ 4.14.1).

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

Modernization:

4. **OCaml 5.x / 5.3.0 port** — `lib/tasty/default.ml` rewritten as a thin
   bridge over stock `Tast_iterator`; 5.3 Typedtree deltas (n-ary functions,
   `Tfunction_cases`, arity changes on `Tpat_var`/`Texp_ident`/`Texp_field`,
   `Pconst_string`); `Caml.*` → `Stdlib.*`.
5. **CLI** — hand-written Cmdliner 2.x term replaces the unsatisfiable
   `[@@deriving cmdliner]` (`bin/main.ml`).
6. **Protobuf** — single `pbrt` 4.x `lib/proto/scip.ml{,i}` replaces the split
   `ocaml-protoc` 2.4 generated modules.

## Honest limitations

- **Referentially closed.** A produced index has *zero external surface*: only
  symbols defined within the indexed tree get `SymbolInformation`; references
  into dependencies are not resolved to their defining package. This is
  robustness-complete but **not cross-repo-complete** — no go-to-definition
  across package boundaries. (`lib/scip.ml:149`, `(* TODO: external symbols *)`.)
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
