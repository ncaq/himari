{-# LANGUAGE Safe #-}
{-# LANGUAGE NoDerivingVia #-}
{-# LANGUAGE NoGeneralizedNewtypeDeriving #-}
{-# LANGUAGE NoTemplateHaskell #-}

-- | "Data.Data" re-exports, hiding symbols that conflict with "GHC.Generics".
module Himari.Prelude.Data
  ( module Export
  ) where

import Data.Data as Export hiding (Fixity, Infix, Prefix)
