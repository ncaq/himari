{-# LANGUAGE Safe #-}
{-# LANGUAGE NoDerivingVia #-}
{-# LANGUAGE NoGeneralizedNewtypeDeriving #-}
{-# LANGUAGE NoTemplateHaskell #-}

-- | "System.FilePath" re-exports, hiding symbols that conflict with "Control.Lens".
module Himari.Prelude.FilePath
  ( module Export
  ) where

import System.FilePath as Export hiding ((<.>))
