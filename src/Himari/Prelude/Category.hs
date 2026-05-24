{-# LANGUAGE Safe #-}
{-# LANGUAGE NoDerivingVia #-}
{-# LANGUAGE NoGeneralizedNewtypeDeriving #-}
{-# LANGUAGE NoTemplateHaskell #-}

-- | "Control.Category" re-exports, hiding symbols that conflict with "Prelude".
module Himari.Prelude.Category
  ( module Export
  ) where

import Control.Category as Export hiding (id, (.))
