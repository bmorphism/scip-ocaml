# scip-ocaml - verified build & indexing recipe (fork notes)

> The only working recipe we found for producing SCIP indexes of real OCaml
> libraries with tjdevries/scip-ocaml, plus an honest assessment of where it
> sits next to other languages' indexers. Upstream (last commit 2023-04-26) is
> an unmaintained proof-of-concept; everything below is what it takes to get
> green indexes out of it in 2026.

## TL;DR

- Indexer: tjdevries/scip-ocaml @ 33e97e6 - the ONLY OCaml->SCIP emitter that exists.
- Build toolchain: OCaml 4.14.1 opam switch (NOT 5.3.0 - see below).
- Mechanism: reads dune-produced .cmt/.cmti, two-pass def/ref walk via Merlin (Tasty).
- Verifier: official scip CLI v0.8.1 (scip stats / scip print).
- Verified green: stdio, sexplib, alcotest, ppxlib (lib).
- Partial/blocked: qcheck (core file crashes the indexer).

## Is this the best OCaml indexer? (honest answer)

For emitting SCIP: yes, because it is the only one. SCIP reserves language id
OCaml=41 in scip.proto, but OCaml does NOT appear on Sourcegraph's recommended
indexer table at all (unlike Go/TS/Java/C++/Python/Ruby/C#, all green with
hover + goto-def + find-refs + cross-repo). No release, no Docker image, no CI,
9 stars, 1 contributor, README still a TODO list.

For navigation quality in general: no - voodoos/ocaml-index is better, but it
does not emit SCIP. It is the official project-wide-occurrences engine (drives
dune build @ocaml-index, ships with Merlin/OCaml-LSP since OCaml 5.2 / 2024),
is compiler-accurate, does proper cross-unit shape reduction, and the exact
failure classes that crash scip-ocaml (ghost _none_ locations, ppx output) are
tracked/handled on its roadmap. It writes .ocaml-index, not SCIP - not a
drop-in for a SCIP pipeline (Sourcegraph, scip-io, etc.).

### Generation UX vs other languages
- scip-typescript / scip-go: one binary, index, no toolchain pinning, CI images. Best-in-class.
- scip-java: drives Gradle/Maven/sbt/Bazel for you.
- scip-ocaml: worst UX of the set. You must hand-build the indexer from an
  opam-monorepo lock that only solves on OCaml 4.14, pin menhir.20211230,
  dune build each target, delete _build/install (duplicate-cmt crash), and for
  ppx-heavy repos delete ppx .pp.ml artifacts. No binary release, no CI image.

If you only need editor navigation, prefer ocaml-index + Merlin/LSP.
If you must produce a .scip file, this recipe is the path.

## Reproducible build (OCaml 4.14.1)

The bundled scip_ocaml.opam.locked is an opam-monorepo lockfile pinning
2022-era forks (ppxlib 0.25.1, merlin 4.8-500, ocaml-compiler-libs). These do
NOT compile on OCaml 5.3.0 (Cmo_format.compunit API break in read_cma.ml;
ppxlib 'Unknown OCaml version 5.3.0'). Build on 4.14.1:

    export OPAMROOT=/root/.opam OPAMYES=1 EDITOR=true
    opam switch create scip414 4.14.1
    opam install --switch scip414 dune opam-monorepo menhir.20211230
    # menhir pin REQUIRED: latest menhir (>=20260209) dropped menhirLib.mli,
    # which the pinned merlin's dune copies.
    cd scip-ocaml
    opam exec --switch scip414 -- opam monorepo pull -l scip_ocaml.opam.locked
    opam exec --switch scip414 -- dune build   # => _build/default/bin/main.exe (~25 MB)

## Indexing a target

Build the target with the SAME compiler as the indexer (4.14.1 - .cmt lock).

    cd <target>
    opam exec --switch scip414 -- dune build          # produce .cmt/.cmti
    rm -rf _build/install                             # REQUIRED dedup .cmt
    #   install/ mirrors default/ -> Map.add_exn key already present
    # ppx-heavy repos: also drop ppx output carrying ghost locations:
    rm -rf _build/default/test ; find _build -name '*.pp.ml' -delete
    opam exec --switch scip414 -- /root/scip-ocaml/_build/default/bin/main.exe index . index.scip
    scip stats --from index.scip                      # verify, official CLI v0.8.1

## Verified results (this fork, scip CLI v0.8.1)

| Target | Ref | Built | docs | occ | defs | index.scip |
|---|---|---|---|---|---|---|
| janestreet/stdio | v0.16.0 | yes | 4 | 304 | 168 | 30 KB |
| janestreet/sexplib | v0.16.0 | yes | 23 | 2,948 | 1,304 | 315 KB |
| mirage/alcotest | HEAD | yes | 85 | 2,623 | 1,206 | 400 KB |
| ocaml-ppx/ppxlib | HEAD (lib only) | yes | 150 | 59,082 | 18,024 | 6.98 MB |
| c-cube/qcheck | partial | partial | 15 | 2,550 | 927 | 298 KB |

ppxlib: _build/default/test holds a *.pp.ml (ppx output) whose .cmt has a
_none_ ghost location -> Option.value_exn None in Tasty.Symbols.find_symbols.
Dropping the test tree indexes the entire library.

qcheck: src/core/QCheck.ml (a real lib file) emits duplicate _none_/col-(-1)
ghost-location locals -> SymbolTracker.add_local Map.add_exn crash. Confirmed
sole blocker (removing only src/core lets the rest index). Upstream bug, no
fix; ocaml-index handles this node class.

## Known scip-ocaml limitations (root-caused here)

1. Duplicate .cmt from _build/install mirroring _build/default -> hard crash. Fix: rm -rf _build/install.
2. Ghost _none_ locations from ppx/synthetic nodes -> add_local / value_exn None crash. No guard upstream. Fix: exclude offending files.
3. No OCaml 5.x support - locked dep graph caps at 4.14.
4. No hover docs / cross-repo / find-implementations parity with tier-1 indexers.

## Publishing this fork

    gh repo fork tjdevries/scip-ocaml --clone=false   # or create your own repo
    git remote add fork <your-fork-url>
    git add README.md && git commit -m 'docs: verified 4.14.1 build + indexing recipe'
    git push fork master
