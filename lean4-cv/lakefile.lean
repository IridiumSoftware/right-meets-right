/-
Mathlib cross-validation lake project for *Right Meets Right*.

The default Lean track at `../lean4/` is hermetic — zero external
dependencies, project-local `Category` typeclass. This sub-project
runs the *same* S-029 closure-equation proof against Mathlib's
`CategoryTheory.Category` to machine-verify that the rewrite chain
in fact transfers verbatim between the two encodings.

Build:
    cd lean4-cv
    lake update    # one-time: fetches Mathlib (multi-GB)
    lake build     # exits 0 iff the Mathlib version of S-029 type-checks

This sub-project is opt-in. Default project workflows (in `../lean4/`)
do not pull Mathlib.
-/

import Lake
open Lake DSL

package «right-meets-right-cv» where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩,
    ⟨`autoImplicit, false⟩,
    ⟨`relaxedAutoImplicit, false⟩
  ]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git"

@[default_target]
lean_lib «CrossValidation» where
  srcDir := "."
