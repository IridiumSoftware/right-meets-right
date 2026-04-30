/-
Module: Category
Description: Minimal categorical typeclass for the *Right Meets Right*
             Lean formalisation.

Self-contained replacement for the small slice of Mathlib's
`CategoryTheory.Category.Basic` that the closure-equation proof
(S-029 in the paper) actually requires. Rationale: supply-chain
reduction. Auditing ~30 lines outright is sounder than trusting
Mathlib's multi-GB transitive graph for the same content.

A reader familiar with Mathlib's `CategoryTheory.Category.Basic`
should recognise this file as exactly the same algebraic structure
with deliberately matching notation:

  - `Category.Hom α β`       ↔  Mathlib's `α ⟶ β` (i.e. `Quiver.Hom`)
  - `≫` (right-associative)  ↔  Mathlib's `≫`     (same glyph, same fixity)
  - `𝟙`                      ↔  Mathlib's `𝟙`

Consequently the S-029 proof body (`rw [sys.cocycle β γ α,
sys.cocycle α β α, sys.diagonal α]` in `TriadicTheorems.lean`)
transfers VERBATIM to a Mathlib instance. The `lean4-cv/` sibling
sub-project in this repository machine-verifies that transfer:
the same proof body type-checks under Mathlib's `Category` with no
edits beyond the import line.

Copyright: (c) Aaron Green, 2026
License: TCL v1.3
-/

universe u v

/-- A category: a collection of objects, hom-sets between them,
    composition, identity morphisms, and the three category laws
    (left/right identity, associativity).

    Universe `u` is the level of the object type; universe `v` is the
    level of the hom-sets.  Matches Mathlib's `Category.{u, v}`
    convention. -/
class Category (Obj : Type u) : Type max u (v+1) where
  /-- The hom-set from `X` to `Y`. -/
  Hom : Obj → Obj → Type v
  /-- The identity morphism on each object. -/
  id : ∀ X : Obj, Hom X X
  /-- Composition of morphisms.  Left-to-right reading:
      `comp f g` is "first `f`, then `g`". -/
  comp : ∀ {X Y Z : Obj}, Hom X Y → Hom Y Z → Hom X Z
  /-- Left identity law:  `𝟙 X ≫ f = f`. -/
  id_comp : ∀ {X Y : Obj} (f : Hom X Y), comp (id X) f = f
  /-- Right identity law: `f ≫ 𝟙 Y = f`. -/
  comp_id : ∀ {X Y : Obj} (f : Hom X Y), comp f (id Y) = f
  /-- Associativity:      `(f ≫ g) ≫ h = f ≫ (g ≫ h)`. -/
  assoc : ∀ {W X Y Z : Obj} (f : Hom W X) (g : Hom X Y) (h : Hom Y Z),
            comp (comp f g) h = comp f (comp g h)

/-- Right-associative composition.  Matches Mathlib's
    `infixr:80 " ≫ " => CategoryStruct.comp`. -/
infixr:80 " ≫ " => Category.comp

/-- Identity morphism notation.  Matches Mathlib's `𝟙`. -/
notation "𝟙" => Category.id
