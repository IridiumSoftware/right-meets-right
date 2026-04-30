/-
Module: CrossValidation
Description: Mathlib-side re-proof of S-029, for cross-validation of
             the project-local `Category` typeclass at `../lean4/Category.lean`.

This file proves the **same** triadic closure equation
(`R γ α ≫ R β γ ≫ R α β = 𝟙 α`) against **Mathlib's**
`CategoryTheory.Category.Basic`, with the **same** three-rewrite proof
body as the primary version at `../lean4/TriadicTheorems.lean`.

The cross-validation discipline guarantees that when the documentation
in `Category.lean` says "the proof body transfers verbatim to
Mathlib," it is machine-verified rather than asserted.

If this file ever falls out of sync with the primary —
e.g. Mathlib's `Category` semantics drift, or a future "tidying"
quietly flattens an asymmetry the primary track depends on — the
build here fails, surfacing the divergence.

Build:
    cd lean4-cv
    lake update
    lake build

Copyright: (c) Aaron Green, 2026
License: TCL v1.3
-/

import Mathlib.CategoryTheory.Category.Basic

universe u v

open CategoryTheory

/-
## Mathlib-parameterised TriadicTranslationSystem

Identical structurally to the primary version in
`../lean4/TriadicTheorems.lean`, but parameterised over Mathlib's
`Category` typeclass.  `α ⟶ β` is Mathlib's hom-notation
(`Quiver.Hom`); `≫` and `𝟙` are Mathlib's built-in operators.
-/

structure TriadicTranslationSystem (C : Type u) [Category.{v} C] where
  R : ∀ α β : C, α ⟶ β
  cocycle : ∀ α β γ : C, R α β ≫ R β γ = R α γ
  diagonal : ∀ α : C, R α α = 𝟙 α

/-
## S-029 — triadic-composition-identity (Mathlib edition)

Statement and proof body are identical to the primary version.
The fact that `rw [...]` succeeds with the same arguments under
Mathlib's `Category` confirms the cross-validation claim from
`../lean4/Category.lean`'s documentation.
-/

theorem triadic_composition_identity
    {C : Type u} [Category.{v} C]
    (sys : TriadicTranslationSystem C) (α β γ : C) :
    sys.R α β ≫ sys.R β γ ≫ sys.R γ α = 𝟙 α := by
  rw [sys.cocycle β γ α, sys.cocycle α β α, sys.diagonal α]
