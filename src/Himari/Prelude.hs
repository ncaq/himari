-- | Alternative to `Prelude`.
module Himari.Prelude
  ( module Export
  ) where

import Control.Applicative as Export
import Control.Category as Export hiding (id, (.))
import Control.DeepSeq as Export
import Control.Lens as Export
import Control.Monad as Export
import Control.Monad.Cont as Export
import Control.Monad.Logger as Export
import Control.Monad.Primitive as Export
import Control.Monad.Reader as Export
import Control.Monad.ST as Export
import Control.Monad.State.Strict as Export
import Control.Monad.Writer.CPS as Export
import Data.Bifoldable as Export
import Data.Bifunctor as Export
import Data.Bitraversable as Export
import Data.Bool as Export
import Data.Either as Export
import Data.Eq as Export
import Data.Foldable as Export
import Data.Function as Export
import Data.Hashable as Export
import Data.Maybe as Export
import Data.Monoid as Export
import Data.Ord as Export
import Data.Ratio as Export
import Data.String as Export
import Data.Time as Export
import Data.Traversable as Export
import Data.Tuple as Export
import Data.Void as Export
import Data.Word as Export
import Debug.Pretty.Simple as Export
import GHC.Generics as Export hiding (from, to)
import System.Directory as Export
import System.FilePath as Export hiding ((<.>))
import System.Process.Typed as Export
import Text.Pretty.Simple as Export
import Text.Show as Export
import UnliftIO as Export
import Prelude as Export

-- Type only.

import Control.Monad.Catch as Export (MonadCatch, MonadMask, MonadThrow)
import Data.ByteString as Export (ByteString, StrictByteString)
import Data.ByteString.Lazy as Export (LazyByteString)
import Data.ByteString.Short as Export (ShortByteString)
import Data.HashMap.Strict as Export (HashMap)
import Data.HashSet as Export (HashSet)
import Data.IntMap as Export (IntMap)
import Data.IntSet as Export (IntSet)
import Data.List as Export (List)
import Data.List.NonEmpty as Export (NonEmpty)
import Data.Map.Strict as Export (Map)
import Data.Sequence as Export (Seq)
import Data.Set as Export (Set)
import Data.Text as Export (StrictText, Text)
import Data.Text.Lazy as Export (LazyText)
import Data.Tree as Export (Tree)
import Data.Vector as Export (MVector, Vector)
