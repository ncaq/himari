{-# LANGUAGE FunctionalDependencies #-}

module Himari.Logger
  ( HasLogger (..)
  ) where

import Himari.Prelude

class HasLogger s a | s -> a where
  logger :: Lens' s a
