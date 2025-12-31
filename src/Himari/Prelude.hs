-- | Alternative to `Prelude`.
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
import System.FilePath as Export hiding ((<.>))
import System.Process.Typed as Export
import Text.Pretty.Simple as Export
import Text.Show as Export
import UnliftIO as Export
import Prelude as Export

-- 部分関数ではない代替関数を提供してくれるsafeライブラリからシンボルを持ってきます。
-- 必要なのは部分関数ではない関数なので、部分関数はいらないのでhidingします。
-- `Safe.Foldable`の方がより汎用的なので、そちらを優先してコンフリクトするものはhidingします。
import Safe as Export hiding
  ( abort
  , assertNote
  , at
  , atNote
  , cycleNote
  , elemIndexJust
  , elemIndexJustNote
  , findIndexJust
  , findIndexJustNote
  , findJust
  , findJustDef
  , findJustNote
  , foldl1Def
  , foldl1May
  , foldl1Note
  , foldl1Note'
  , foldr1Def
  , foldr1May
  , foldr1Note
  , fromJustNote
  , headErr
  , headNote
  , indexNote
  , initNote
  , lastNote
  , lookupJust
  , lookupJustNote
  , maximumBound
  , maximumBoundBy
  , maximumBounded
  , maximumByDef
  , maximumByMay
  , maximumByNote
  , maximumDef
  , maximumMay
  , maximumNote
  , minimumBound
  , minimumBoundBy
  , minimumBounded
  , minimumByDef
  , minimumByMay
  , minimumByNote
  , minimumDef
  , minimumMay
  , minimumNote
  , predNote
  , readNote
  , scanl1Note
  , scanr1Note
  , succNote
  , tailErr
  , tailNote
  , toEnumNote
  )
import Safe.Exact as Export hiding
  ( dropExact
  , dropExactNote
  , splitAtExact
  , splitAtExactNote
  , takeExact
  , takeExactNote
  , zip3Exact
  , zip3ExactNote
  , zipExact
  , zipExactNote
  , zipWith3Exact
  , zipWith3ExactNote
  , zipWithExact
  , zipWithExactNote
  )
import Safe.Foldable as Export hiding
  ( findJust
  , findJustNote
  , foldl1Note
  , foldr1Note
  , maximumByNote
  , maximumNote
  , minimumByNote
  , minimumNote
  )

-- Safe alternatives to partial functions from Data.Char.
-- These functions return Maybe instead of throwing exceptions.
import Himari.Char as Export
  ( chrMay
  , digitToIntMay
  , intToDigitMay
  )

-- aeson系には被りそうな関数名が多いので、hidingしたり、シンボルを個別importします。
import Data.Aeson as Export hiding
  ( decode
  , decode'
  , decodeFileStrict
  , decodeFileStrict'
  , decodeStrict
  , decodeStrict'
  , decodeStrictText
  , eitherDecode'
  , eitherDecodeFileStrict'
  , eitherDecodeStrict'
  , throwDecode'
  , throwDecodeStrict'
  , (.=)
  )
import Data.Aeson.Encode.Pretty as Export
  ( encodePretty
  , encodePretty'
  , encodePrettyToTextBuilder
  , encodePrettyToTextBuilder'
  )
import Data.Aeson.QQ.Simple as Export
import Deriving.Aeson as Export

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
