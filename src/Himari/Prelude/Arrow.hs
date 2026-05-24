{-# LANGUAGE Safe #-}
{-# LANGUAGE NoDerivingVia #-}
{-# LANGUAGE NoGeneralizedNewtypeDeriving #-}
{-# LANGUAGE NoTemplateHaskell #-}

-- | "Control.Arrow" re-exports, hiding symbols that conflict with "Data.Bifunctor".
module Himari.Prelude.Arrow
  ( module Export
  ) where

import Control.Arrow as Export hiding (first, second)
