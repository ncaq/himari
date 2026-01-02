-- | System.FilePath re-exports, hiding symbols that conflict with lens.
module Himari.Prelude.FilePath
  ( module Export
  ) where

import System.FilePath as Export hiding ((<.>))
