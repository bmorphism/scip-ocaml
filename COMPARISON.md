# What SCIP reveals across the four indexed codebases

All numbers from `scip` CLI v0.8.1 over the indexes scip-ocaml v0.2.0 produces
for [rocq-prover/rocq](https://github.com/rocq-prover/rocq),
[gwaithimirdain/narya](https://github.com/gwaithimirdain/narya),
[engboris/stellogen](https://github.com/engboris/stellogen), and the OCaml
subtree of [plurigrid/place](https://github.com/plurigrid/place)
(`cct-reading-group`). All four on OCaml 5.3.0.

## The headline is a negative: the shared root is invisible

| | rocq | narya | stellogen | place |
|---|--:|--:|--:|--:|
| distinct global symbols | 33,013 | 7,280 | 1,011 | 25 |
| symbols common to all four | **0** | | | |
| any pairwise symbol overlap | **0** | | | |
| **external-surface occurrences** | **0** | **0** | **0** | **0** |

Not one occurrence in any index references a symbol outside its own project.
All four are OCaml; all depend on the same substrate (`Stdlib`, and most on
`Base`/`Fmt`/`Map`/`List`). The one thing they genuinely share — the standard
library — is exactly what SCIP shows here as *absent*. scip-ocaml is
referentially closed, so the commonality is encoded as a hole, not an edge.
The only symbol strings literally common to all four are `local 0`, `local 1`,
… — document-scoped, meaningless. They are four disjoint forests grown from one
invisible root.

## Bases of comparison

### 1. Reference density (occ ÷ definitions) — clusters by size, not domain
- rocq **4.27**, narya **4.34** — a theorem prover and a dependent type
  checker, near-identical.
- stellogen **2.42**, place **2.58** — the two small ones, also paired.

Rocq and Narya land on the same ~4.3 references-per-definition despite different
domains: a property of mature OCaml at scale, not of what the code is about.

### 2. Definition-kind mix (SCIP descriptor suffix) — function- vs value-dense
Share of global definition symbols:

| | Type `#` | Method `().` | Term `.` |
|---|--:|--:|--:|
| rocq | 15% | **63%** | 22% |
| narya | 32% | **47%** | 21% |
| stellogen | 9% | 24% | **67%** |
| place | 44% | 8% | 48% |

The proof assistants are function-dense (Method-dominant); stellogen the
interpreter is value/constructor-dense (Term-dominant). The shape read off SCIP
matches what each project is.

### 3. The `type t` convention — a maturity tell
`type t` symbols: rocq **487**, narya **109**, stellogen **0**, place **0**.
The two established assistants lean on OCaml's `Module.t` idiom; the two
younger/smaller projects never use it.

### 4. Nesting depth — inverted vs size *(new)*
| | avg descriptors | avg dir depth | max dir depth |
|---|--:|--:|--:|
| rocq | 4.32 | 2.33 | 5 |
| narya | 5.19 | 3.00 | 4 |
| stellogen | 5.36 | 3.00 | 3 |
| place | 3.76 | 2.08 | 3 |

The *largest* codebase is the *shallowest*: Rocq nests least (4.32 descriptors,
broad-and-flat — many top-level `kernel/…`, `engine/…` modules), while the far
smaller narya and stellogen nest deeper. Size does not predict structural depth;
here it anti-correlates.

### 5. Documentation coverage — one outlier *(new)*
Symbols carrying a hover type-signature (` ```ocaml … ``` `):

| | documented | coverage |
|---|--:|--:|
| rocq | 57,467 / 57,612 | **99.7%** |
| narya | 9,433 / 9,439 | **99.9%** |
| place | 26 / 26 | **100%** |
| stellogen | 1,514 / 1,953 | **77.5%** |

Three of four are ~100% — the indexer renders the inferred type for nearly every
definition. Stellogen is the lone outlier: ~22% of its definitions carry no
type-signature, concentrated in its menhir/sedlex-generated parser and lexer,
whose synthesized types the indexer does not render.

## One line
Everything SCIP *can* see across the four is real but secondary — density ≈4.3
at scale, function-vs-value shape, the `t` convention, flat-vs-deep nesting,
~100% doc coverage with one generated-code outlier. The headline is the
*invisible* shared root: the one true commonality is the standard library, and
referential closure is exactly why the indexes can't show it. Closing that —
external-symbol resolution — is the open item v0.2.0 only set up (symbols are
now project-scoped, so the edges *could* be drawn) but does not yet implement.
