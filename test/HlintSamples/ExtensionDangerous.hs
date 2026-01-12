{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE UndecidableInstances #-}

-- Sample file to test extension restriction hlint rules
-- This file intentionally uses dangerous and deprecated extensions
module HlintSamples.ExtensionDangerous where

import Himari

-- AllowAmbiguousTypes example
class AmbiguousClass a where
  ambiguousMethod :: Int

-- ImplicitParams example
implicitParamsExample :: (?x :: Int) => Int
implicitParamsExample = ?x + 1

-- UndecidableInstances example (combined with FlexibleInstances from GHC2024)
class ShowWrapper a where
  showWrapper :: a -> Text

instance (Show a) => ShowWrapper a where
  showWrapper = convert . show
