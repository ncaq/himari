-- | Type-level programming re-exports from "Data.Type.Coercion" and "Data.Type.Equality".
--
-- Hides conflicting symbols between the two modules.
module Himari.Prelude.TypeLevel
  ( module Export
  ) where

import Data.Type.Coercion as Export hiding (sym, trans)
import Data.Type.Equality as Export hiding (outer, sym, trans)
