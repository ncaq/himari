-- | Re-exports for case conversion of identifiers.
-- "Text.Casing".
module Himari.Prelude.Casing
  ( module Export
  ) where

-- casing exposes mostly safe pure conversion functions,
-- but @dropPrefix@ has a name too generic and likely to conflict, so we hide only it.
import Text.Casing as Export hiding (dropPrefix)
