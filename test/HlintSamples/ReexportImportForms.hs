{-# OPTIONS_GHC -Wno-x-partial #-}

-- Sample file to test how hlint rules for re-exported symbols interact with import forms.
-- `head` and `last` are hidden from Himari,
-- so those unqualified names refer to something else here.
module HlintSamples.ReexportImportForms where

import Data.List.NonEmpty (head)
import Data.List.NonEmpty qualified as NE
import Himari hiding (head, last)
import Himari qualified as H

-- Qualified use through Himari (should warn)
useQualifiedHead :: [Int] -> Int
useQualifiedHead = H.head

useQualifiedReadFile :: IO String
useQualifiedReadFile = H.readFile "foo.txt"

-- Hiding some names does not hide the others (should warn)
useTail :: [Int] -> [Int]
useTail = tail

-- `head` is the total one of Data.List.NonEmpty
-- because the one of Himari is hidden (should NOT warn)
useNonEmptyHead :: NonEmpty Int -> Int
useNonEmptyHead = head

useNonEmptyHeadQualified :: NonEmpty Int -> Int
useNonEmptyHeadQualified = NE.head

-- A total function defined by the user under the name hidden from Himari (should NOT warn)
last :: [Int] -> Maybe Int
last = lastMay

useOwnLast :: [Int] -> Maybe Int
useOwnLast = last
