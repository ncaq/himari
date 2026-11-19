{-# OPTIONS_GHC -Wno-x-partial #-}

-- Sample file to test that hlint rules match symbols imported from Himari
-- with an explicit import list.
module HlintSamples.ReexportExplicitImport where

import Himari (IO, Int, Maybe, String, head, headMay, readFile)

-- These should trigger warnings
useHead :: [Int] -> Int
useHead = head

useReadFile :: IO String
useReadFile = readFile "foo.txt"

-- This should NOT trigger a warning
useHeadMay :: [Int] -> Maybe Int
useHeadMay = headMay
