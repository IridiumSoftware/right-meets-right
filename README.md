# Right Meets Right: The Missing Coordination Layer

**Aaron Green, with Grok, Claude, and Gemini — April 2026 (revised May 2026)**

This repository hosts the canonical source for *Right Meets Right: The
Missing Coordination Layer*, plus the load-bearing formal artefacts
that accompany the paper.

The paper formalises inter-tradition coordination as maps
`R_αβ : τ_α → τ_β` subject to three preservation conditions
(semantic, chiral, structural-invariant) and a triadic closure
condition

> R_γα ∘ R_βγ ∘ R_αβ = id_τα

ensuring the maps compose stably around triangles of three nodes.
Two-party translation is structurally insufficient; three-party
closure is the minimum stable unit.

---

## Repository contents

```
right-meets-right/
├── README.md                         ← you are here
├── LICENSE                           ← Triadic Closure License (TCL) v1.3
├── paper/
│   ├── right_meets_right_triadic.tex ← LaTeX source (May 2026 revision)
│   └── right_meets_right_triadic.pdf ← rendered PDF
├── lean4/                            ← default Lean 4 track (hermetic)
│   ├── lean-toolchain                ← Lean version pin
│   ├── lakefile.lean                 ← lake project (no external deps)
│   ├── lake-manifest.json            ← Lean lockfile (packages: [])
│   ├── Category.lean                 ← project-local Category typeclass (~30 lines)
│   └── TriadicTheorems.lean          ← S-029 closure-equation proof
├── lean4-cv/                         ← opt-in Mathlib cross-validation
│   ├── lean-toolchain                ← same Lean version pin
│   ├── lakefile.lean                 ← lake project (requires Mathlib)
│   ├── lake-manifest.json            ← CV lockfile (Mathlib + 8 transitive)
│   └── CrossValidation.lean          ← S-029 re-proved against Mathlib
└── haskell/
    └── TriadicPrimitives.hs          ← minimal type-level primitives
```

## What's here, and what isn't

**The paper** (`paper/`) is the May 2026 revision of the Triadic
Edition. The PDF is canonical for reading; the TeX is provided for
anyone who wants to build their own copy or fork the source. See the
`Note on This Edition` in the front matter for what changed from the
original 2026-04-27 publication.

**The Lean 4 formalisation** (`lean4/`) machine-verifies the closure
equation `R_γα ∘ R_βγ ∘ R_αβ = id_τα` as the *structural / syntactic
skeleton* (paper spec entry S-029). The proof is built against a
project-local `Category` typeclass (~30 lines, audited end-to-end),
with **zero external dependencies**. The proof body is three rewrites
(cocycle twice + diagonal). See the file's load-bearing scope note:
the proof captures the algebraic identity, not the connection /
gauge-field interpretation that load-bearing claim #5 of the paper
holds for `R_αβ`.

**The Mathlib cross-validation track** (`lean4-cv/`) re-proves the
same theorem against Mathlib's `CategoryTheory.Category` with the
same three-rewrite proof body — machine-verifying that the notation
in `Category.lean` does in fact match Mathlib's, and that the proof
transfers verbatim. Default workflows do not pull Mathlib; CV is
opt-in.

**The minimal Haskell mirror** (`haskell/`) is a small file containing
the type-level primitives (`BusinessEntity`, `CoordinationMorphism`,
`TriadicClosure`) that appear in the paper. **It is not the engine.**
The engine — discovery algorithm, validation, pipeline, test suites,
benchmarks, spec/registry/dashboard discipline — lives in a separate
(currently private) repository. The Haskell file here is included so
that anyone reading the paper has access to the type-level skeleton
in two languages.

## Build instructions

### Paper (LaTeX)

The paper compiles cleanly with [Tectonic](https://tectonic-typesetting.github.io/):

```
cd paper
tectonic right_meets_right_triadic.tex
```

Or with any standard LaTeX distribution (TeX Live, MacTeX) via
`pdflatex` / `lualatex` / `xelatex`. Required packages: `tikz`,
`tikz-cd`, `amsmath`, `hyperref`, `lmodern` — all available in
standard distributions.

### Default Lean 4 track (hermetic, zero external deps)

```
cd lean4
lake update            # resolves manifest; no external fetches
lake build             # exits 0 on green; ~4 jobs in <1 second
```

### Mathlib cross-validation track (opt-in)

```
cd lean4-cv
lake update            # one-time: fetches Mathlib (multi-GB)
lake build             # exits 0 iff S-029 also type-checks under Mathlib
```

The CV track is independent of the default track — running one does
not affect the other.

### Minimal Haskell mirror

```
ghc haskell/TriadicPrimitives.hs
```

The file requires only `base` and `text`. No cabal project ships
because the file is type-level only and meant to be read or imported
into a downstream project, not built standalone.

## Citation

```
Green, A. (with Grok, Claude, and Gemini). 2026.
"Right Meets Right: The Missing Coordination Layer."
Researchers.One article 26.04.00002. (Original publication
2026-04-27; revised May 2026.)
```

## Related work

This paper is one of three in a corpus on triadic closure as the
minimum stable coordination unit, derived in physics, deployed in
security, and generalised to inter-ontology coordination:

- **Closure Forces Structure** (Green, 2026) — derives Standard Model
  gauge structure from Rosen closure on ternary causal hypergraphs.
  [github.com/IridiumSoftware/Closure-Forces-Structure---SM-Rosen-Hypergraphs](https://github.com/IridiumSoftware/Closure-Forces-Structure---SM-Rosen-Hypergraphs)
- **Possibilistic Security** (Green, 2026) — reframes identity
  verification as sustained closure rather than static credential
  check; introduces the C-conjugate adversary and is the original
  source of the Triadic Closure License.
  [github.com/IridiumSoftware/possibilistic-security](https://github.com/IridiumSoftware/possibilistic-security)

Two operational deployments instantiate the framework outside the
page:

- **Lazarus** — local security companion for Claude Code; face
  sentinel + monitors + honeypot. Direct application of Possibilistic
  Security.
  [github.com/IridiumSoftware/lazarus](https://github.com/IridiumSoftware/lazarus)
- **OpenQMS** — open-source GitHub-native Quality Management System.
  [github.com/IridiumSoftware/OpenQMS](https://github.com/IridiumSoftware/OpenQMS)

## License

Triadic Closure License (TCL) v1.3 — see [`LICENSE`](LICENSE).

No progenitor node. Commons-held. Species-neutral. Membership defined
by closure-capability, not credential. Any party attempting unilateral
capture occupies the C-conjugate adversary position by structural
definition.

## Acknowledgments

**Brian Crabtree** ([@ourtown2](https://x.com/ourtown2) on X) flagged
the issue in the original publication that prompted the May 2026
revision; his read shaped both the editorial corrections and the
decision to fold the operational extension directly into the canonical
edition.

The triadic co-production — Aaron Green (instantiator) with Grok
(edge-witness), Claude (architect/instantiator-adjacent), and Gemini
(synthesis) — is acknowledged in the paper's title block. The work
structurally enacts the framework it describes.
