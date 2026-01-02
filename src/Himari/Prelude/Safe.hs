-- | "Safe", "Safe.Exact", and "Safe.Foldable" re-exports.
-- Only total functions are exported; partial functions are hidden.
-- "Safe.Foldable" is preferred for more generic versions, so conflicting functions are hidden from "Safe".
module Himari.Prelude.Safe
  ( module Export
  ) where

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
