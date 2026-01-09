-- | "System.Process.Typed" re-exports, hiding symbols that conflict with "UnliftIO.Environment".
module Himari.Prelude.Process
  ( module Export
  ) where

import System.Process.Typed as Export hiding (setEnv)
