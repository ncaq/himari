-- | Re-exports for here documents and string interpolation.
-- "Data.String.Here".
module Himari.Prelude.Here
  ( module Export
  ) where

-- here exposes compile-time QuasiQuoters that are safe at runtime,
-- but @i@ and @template@ have names too generic and likely to conflict, so we hide only them.
-- The hidden quasiquoters are still usable via "Data.String.Here.Interpolated".
import Data.String.Here as Export hiding (i, template)
