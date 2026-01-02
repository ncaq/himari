-- | GHC.Generics re-exports, hiding symbols that conflict with lens.
module Himari.Prelude.Generics
  ( module Export
  ) where

import GHC.Generics as Export hiding (from, to)
