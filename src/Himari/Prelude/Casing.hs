-- | Re-exports for case conversion of identifiers.
-- "Text.Casing".
module Himari.Prelude.Casing
  ( module Export
  ) where

-- casing exposes mostly safe pure conversion functions,
-- but @dropPrefix@, @toWords@, and @fromWords@ have names too generic and likely to conflict,
-- so we hide them.
import Text.Casing as Export hiding (dropPrefix, fromWords, toWords)
