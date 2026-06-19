/-
Module: TriadicTheorems
Description: Formal verification of triadic coordination — structural skeleton
Copyright: (c) Aaron Green, 2026
License: TCL v1.3

Machine-verifies the closure equation `R_γα ∘ R_βγ ∘ R_αβ = id_τα`
from *Right Meets Right* (Researchers.One 26.04.00002),
§"Triadic Closure Requirement". This is the formal-proof artefact
referenced by the paper's Section 2 footnote on equation (T) and by
References & Precursor Works.

LOAD-BEARING SCOPE NOTE
=======================

RMR's load-bearing claim #5 (Appendix A.6 in the May 2026 revision):
*"R_αβ as connection (gauge field), not domain morphism. Cross-layer
maps are connections; intra-layer maps are morphisms. The distinction
is type-level."*

This file treats R_αβ as a categorical morphism. That formalisation
captures the **structural / syntactic skeleton** of the closure
equation only. The connection / gauge-field interpretation that is
load-bearing in RMR is *not* captured by this proof and remains a
semantic commitment of the published paper.

DEPENDENCY NOTE
===============

This file builds against the project-local `Category` typeclass
(`Category.lean` in this same directory) — a ~30-line minimal
categorical structure with **zero external dependencies**, audited
end-to-end. The local typeclass deliberately matches Mathlib's
notation (`≫` right-associative at fixity 80, `𝟙` for identity), so
the proof body type-checks verbatim against Mathlib's
`CategoryTheory.Category.Basic`. The `lean4-cv/` sibling sub-project
in this repository runs that Mathlib re-proof as opt-in
cross-validation.
-/

import Category

universe u v

/-
## Business entity types
Lean-side mirror of the Haskell `BusinessEntity` ADT. Kept here for
future cross-track correspondence theorems (S-035). Not used by S-029.
Pure base-Lean; no external dependency.
-/

inductive BusinessEntityType : Type
  | changelog
  | artefact
  | ontology
  | spec_file
  | test_suite
  | manifest

structure BusinessEntity : Type where
  id : String
  entity_type : BusinessEntityType
  content : String

/-
## Triadic Translation System

The categorical setup for the closure equation. R_αβ : α ⟶ β are
morphisms in some category `C`. The cocycle (C) and diagonal axioms
together imply the closure equation (T) — proved as
`triadic_composition_identity` below.

Paper convention vs Lean convention:

  paper (RTL `∘`):   R_βγ ∘ R_αβ = R_αγ                      (cocycle, C)
  Lean (LTR `≫`):   R α β ≫ R β γ = R α γ                   (cocycle, C)

Both are the same equation under their respective composition
conventions: "translate α to β, then β to γ, equals translate α to γ".
-/

structure TriadicTranslationSystem (C : Type u) [Category.{u, v} C] where
  /-- R_αβ : the translation morphism from object α to object β. -/
  R : ∀ α β : C, Category.Hom α β
  /-- Cocycle (C) from RMR §"Triadic Closure Requirement", eq. (C):
      composing partial translations agrees with the direct translation. -/
  cocycle : ∀ α β γ : C, R α β ≫ R β γ = R α γ
  /-- Diagonal axiom: the self-translation is the identity. Implicit in
      RMR's framing of (T) as the closed-loop case of (C); without it
      the cocycle fixes only `R α α` as idempotent (R_αα ≫ R_αα = R_αα),
      not as identity. -/
  diagonal : ∀ α : C, R α α = 𝟙 α

/-
## S-029 — triadic-composition-identity

The closure equation (T) from RMR §"Triadic Closure Requirement":

    R_γα ∘ R_βγ ∘ R_αβ = id_τα                       (paper, RTL ∘)
    sys.R α β ≫ sys.R β γ ≫ sys.R γ α = 𝟙 α         (Lean, LTR ≫)

These are the same equation under different composition conventions.
The Lean statement reads "translate α→β, then β→γ, then γ→α; the
result is the identity on α", i.e. information that traverses the
triangle returns home unchanged.

`≫` is declared right-associative (infixr:80) in `Category.lean`,
matching Mathlib, so the goal parses as
`sys.R α β ≫ (sys.R β γ ≫ sys.R γ α)`.

Proof (paper-matching, derived from cocycle + diagonal):

      sys.R α β ≫ (sys.R β γ ≫ sys.R γ α)
    = sys.R α β ≫ sys.R β α            [cocycle β γ α: R_βγ ≫ R_γα = R_βα]
    = sys.R α α                          [cocycle α β α: R_αβ ≫ R_βα = R_αα]
    = 𝟙 α                                [diagonal α]
-/

theorem triadic_composition_identity
    {C : Type u} [Category.{u, v} C]
    (sys : TriadicTranslationSystem C) (α β γ : C) :
    sys.R α β ≫ sys.R β γ ≫ sys.R γ α = 𝟙 α := by
  rw [sys.cocycle β γ α, sys.cocycle α β α, sys.diagonal α]
