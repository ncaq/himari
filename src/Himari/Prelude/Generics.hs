{-# LANGUAGE Safe #-}
{-# LANGUAGE NoDerivingVia #-}
{-# LANGUAGE NoGeneralizedNewtypeDeriving #-}
{-# LANGUAGE NoTemplateHaskell #-}

-- | "GHC.Generics" re-exports, hiding symbols that conflict with "Control.Lens".
module Himari.Prelude.Generics
  ( module Export
  ) where

import GHC.Generics as Export hiding (Fixity, Infix, Prefix, from, to)
