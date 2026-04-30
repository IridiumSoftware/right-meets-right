import Lake
open Lake DSL

package «right-meets-right-lean» where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩,
    ⟨`autoImplicit, false⟩,
    ⟨`relaxedAutoImplicit, false⟩
  ]

@[default_target]
lean_lib «TriadicTheorems» where
  srcDir := "."

lean_lib «Category» where
  srcDir := "."
