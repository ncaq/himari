{-# OPTIONS_GHC -Wno-x-partial #-}

-- Sample file to test that hlint rules match symbols re-exported through Himari.Prelude.
-- Importing Himari.Prelude directly is needed inside himari itself to avoid import cycles.
module HlintSamples.ReexportHimariPrelude where

import Himari.Prelude

-- These should trigger warnings
useHead :: [Int] -> Int
useHead = head

useFoldl1 :: [Int] -> Int
useFoldl1 = foldl1 (+)

useBifoldl1 :: (Int, Int) -> Int
useBifoldl1 = bifoldl1 (+)

useFromJust :: Maybe Int -> Int
useFromJust = fromJust

useReadFile :: IO String
useReadFile = readFile "foo.txt"

useSingular :: [Int] -> Int
useSingular xs = xs ^. singular traverse

useStringException :: StringException
useStringException = stringException "a"

-- These should NOT trigger warnings
useHeadMay :: [Int] -> Maybe Int
useHeadMay = headMay

useCatch :: IO ()
useCatch = catch (pure ()) (\(_ :: IOException) -> pure ())
