{-|
Module      : TriadicPrimitives
Description : Minimal Haskell mirror of the categorical primitives
              from /Right Meets Right: The Missing Coordination Layer/.
Copyright   : (c) Aaron Green, 2026
License     : TCL v1.3

This module ships the type-level primitives that appear in the paper —
the BusinessEntity ADT, CoordinationMorphism with explicit source/target,
and TriadicClosure as a triple of edges. It is deliberately minimal:
the discovery / validation / pipeline / property-test infrastructure
that constitutes the actual /engine/ lives in a separate (currently
private) repository (Triadic Coordination Engine).

The Lean formalisation in @lean4/@ (project-local @Category.lean@ +
@TriadicTheorems.lean@) is the load-bearing artefact — it /proves/
the closure equation @triadic_composition_identity@ as the structural
skeleton (S-029). This Haskell file is a type-level companion: it
shows that the primitives compose at the value level, but does not
attempt any proof-of-correctness via Haskell's type system beyond
what is type-trivial.

For the published paper, the relevant claims are proven in Lean.
For an executable instantiation, see the Lean track.

== Scope note (load-bearing)

The paper's load-bearing claim #5 holds @R_αβ@ as a /connection/
(gauge field), not a domain morphism. This module's
@CoordinationMorphism@ is encoded as a domain morphism with explicit
source and target — the structural / syntactic skeleton only. The
connection / gauge-field interpretation remains a semantic commitment
of the published paper.
-}

{-# LANGUAGE GADTs            #-}
{-# LANGUAGE OverloadedStrings #-}

module TriadicPrimitives
  ( -- * Business entities
    BusinessEntity (..)
  , BusinessEntityType (..)
  , entityType
    -- * Coordination morphisms (structural skeleton)
  , CoordinationMorphism (..)
  , idMorphism
    -- * Triadic closure
  , TriadicClosure (..)
  ) where

import Data.Text (Text)
import qualified Data.Text as Text

--------------------------------------------------------------------------------
-- Business entities
--------------------------------------------------------------------------------

-- | The six entity variants discussed in the paper. Each carries a name
-- (Text) and minimal payload appropriate to its kind. The set is closed:
-- @entityType@ is total over all six constructors.
data BusinessEntity
  = Changelog  Text Text                    -- ^ Path-dependent historical record
  | Artefact   Text Text                    -- ^ Generated output with provenance
  | Ontology   Text [(Text, Text)]          -- ^ Conceptual relationship mapping
  | SpecFile   Text Text                    -- ^ Formal specification
  | TestSuite  Text [Text]                  -- ^ Validation against spec
  | Manifest   Text [Text]                  -- ^ Git-based recordkeeping
  deriving (Show, Eq, Ord)

-- | The six type tags in the same order as the constructors of
-- @BusinessEntity@.
data BusinessEntityType
  = TyChangelog
  | TyArtefact
  | TyOntology
  | TySpecFile
  | TyTestSuite
  | TyManifest
  deriving (Show, Eq, Ord, Enum, Bounded)

-- | Total over all six constructors.
entityType :: BusinessEntity -> BusinessEntityType
entityType (Changelog  {}) = TyChangelog
entityType (Artefact   {}) = TyArtefact
entityType (Ontology   {}) = TyOntology
entityType (SpecFile   {}) = TySpecFile
entityType (TestSuite  {}) = TyTestSuite
entityType (Manifest   {}) = TyManifest

--------------------------------------------------------------------------------
-- Coordination morphisms (structural skeleton)
--------------------------------------------------------------------------------

-- | A coordination morphism in the structural / syntactic register.
-- Carries an explicit source and target. (The connection /
-- gauge-field interpretation is a semantic commitment of the
-- published paper, not captured by this Haskell encoding — see the
-- module-level scope note.)
data CoordinationMorphism a b = CoordinationMorphism
  { morphismSource :: a
  , morphismTarget :: b
  , morphismLabel  :: Text
  } deriving (Show, Eq)

-- | The trivial identity-shaped morphism for an entity. Pedagogical
-- only; no algebraic content beyond constructor application.
idMorphism :: a -> CoordinationMorphism a a
idMorphism x = CoordinationMorphism x x (Text.pack "id")

--------------------------------------------------------------------------------
-- Triadic closure
--------------------------------------------------------------------------------

-- | A triadic closure as a triple of coordination morphisms. The
-- closure equation
--
-- > R_γα ∘ R_βγ ∘ R_αβ = id_τα
--
-- is /not/ enforced by Haskell's type system in this minimal module.
-- It is proved formally in Lean — see @lean4/TriadicTheorems.lean@ in
-- this repository, theorem @triadic_composition_identity@ (spec entry
-- S-029, structural skeleton scope per the paper's load-bearing
-- claim #5).
data TriadicClosure a b c = TriadicClosure
  { edgeAB :: CoordinationMorphism a b      -- ^ R_αβ
  , edgeBC :: CoordinationMorphism b c      -- ^ R_βγ
  , edgeCA :: CoordinationMorphism c a      -- ^ R_γα
  } deriving (Show, Eq)
