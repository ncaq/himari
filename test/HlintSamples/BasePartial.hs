{-# OPTIONS_GHC -Wno-x-partial #-}

-- Sample file to test base library hlint rules
-- This file intentionally uses partial functions to test hlint rules
module HlintSamples.BasePartial where

import Data.Char (intToDigit) -- test only partial functions
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

-- Numeric integer-showing functions are partial (throw on negative input)
useShowHex :: Int -> String
useShowHex n = showHex n ""

useShowInt :: Int -> String
useShowInt n = showInt n ""

useShowOct :: Int -> String
useShowOct n = showOct n ""

useShowBin :: Int -> String
useShowBin n = showBin n ""

-- A base of 12 avoids hlint suggesting showHex/showOct/showBin
useShowIntAtBase :: Int -> String
useShowIntAtBase n = showIntAtBase 12 intToDigit n ""
