{-# OPTIONS_GHC -Wno-x-partial #-}

-- Sample file to test base library hlint rules
-- This file intentionally uses partial functions to test hlint rules
module HlintSamples.BasePartial where

import Data.List qualified as L
import Data.List.NonEmpty qualified as NE
import Debug.Trace (trace, traceM, traceShow)
import Himari

-- These should trigger warnings
useHead :: [Int] -> Int
useHead = head

useHeadQualified :: [Int] -> Int
useHeadQualified = L.head

-- This should NOT trigger a warning (NonEmpty.head is safe)
useNonEmptyHead :: NonEmpty Int -> Int
useNonEmptyHead = NE.head

-- Debug.Trace should trigger warnings
useTrace :: Int -> Int
useTrace x = trace "debug" x

useTraceShow :: (Show a) => a -> a
useTraceShow x = traceShow x x

useTraceM :: IO ()
useTraceM = traceM "debug"
