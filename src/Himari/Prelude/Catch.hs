{-# LANGUAGE Safe #-}
{-# LANGUAGE NoDerivingVia #-}
{-# LANGUAGE NoGeneralizedNewtypeDeriving #-}
{-# LANGUAGE NoTemplateHaskell #-}

-- | Re-exports from "Control.Monad.Catch" that don't conflict with "UnliftIO".
--
-- Functions that conflict with "UnliftIO" are hidden.
-- Use 'catch', 'bracket', 'finally', 'mask', etc. from "UnliftIO" instead.
module Himari.Prelude.Catch
  ( module Control.Monad.Catch
  ) where

import Control.Monad.Catch hiding
  ( Handler
  , bracket
  , bracketOnError
  , bracket_
  , catch
  , catchJust
  , catches
  , finally
  , handle
  , handleJust
  , mask
  , mask_
  , onException
  , try
  , tryJust
  , uninterruptibleMask
  , uninterruptibleMask_
  )
