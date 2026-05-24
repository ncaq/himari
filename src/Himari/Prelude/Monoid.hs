{-# LANGUAGE Safe #-}
{-# LANGUAGE NoDerivingVia #-}
{-# LANGUAGE NoGeneralizedNewtypeDeriving #-}
{-# LANGUAGE NoTemplateHaskell #-}

-- | "Data.Monoid" and "Data.Semigroup" re-exports, hiding conflicting symbols.
module Himari.Prelude.Monoid
  ( module Export
  ) where

import Data.Monoid as Export hiding (First, Last, getFirst, getLast)
import Data.Semigroup as Export hiding (First, Last, getFirst, getLast)
