-- | Alternative to "Prelude".
module Himari.Prelude
  ( module Export
  -- Type only re-exports.
  , ByteString
  , StrictByteString
  , LazyByteString
  , ShortByteString
  , HashMap
  , HashSet
  , IntMap
  , IntSet
  , List
  , NonEmpty
  , Map
  , Seq
  , Set
  , StrictText
  , Text
  , LazyText
  , Tree
  , MVector
  , Vector
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
import Data.Convertible as Export
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
import Himari.Prelude.Aeson as Export
import Himari.Prelude.Safe as Export
import System.FilePath as Export hiding ((<.>))
import System.Process.Typed as Export
import Text.Pretty.Simple as Export
import Text.Show as Export
import UnliftIO as Export
import Prelude as Export

-- Type only.

import Control.Monad.Catch as Export (MonadCatch, MonadMask, MonadThrow)
import Data.ByteString (ByteString, StrictByteString)
import Data.ByteString.Lazy (LazyByteString)
import Data.ByteString.Short (ShortByteString)
import Data.HashMap.Strict (HashMap)
import Data.HashSet (HashSet)
import Data.IntMap.Strict (IntMap)
import Data.IntSet (IntSet)
import Data.List (List)
import Data.List.NonEmpty (NonEmpty)
import Data.Map.Strict (Map)
import Data.Sequence (Seq)
import Data.Set (Set)
import Data.Text (StrictText, Text)
import Data.Text.Lazy (LazyText)
import Data.Tree (Tree)
import Data.Vector (MVector, Vector)
