module Himari.PreludeSpec (spec) where

import Data.Char (digitToInt, isHexDigit)
import Himari
import Test.QuickCheck
import Test.Syd

spec :: Spec
spec = do
  describe "fromHexDigit" $ do
    it "returns Just for all hex digits (0-9, a-f, A-F)" $ do
      property $ \c ->
        isHexDigit c ==> fromHexDigit c == Just (digitToInt c {- HLINT ignore "Avoid restricted function" -})

    it "returns Nothing for non-hex characters" $ do
      property $ \c ->
        not (isHexDigit c) ==> isNothing (fromHexDigit c :: Maybe Int)

    it "matches digitToInt for all hex digits exhaustively" $ do
      let hexChars = ['0' .. '9'] <> ['a' .. 'f'] <> ['A' .. 'F']
      forM_ hexChars $ \c ->
        fromHexDigit c `shouldBe` Just (digitToInt c {- HLINT ignore "Avoid restricted function" -})

  describe "fromDecDigit" $ do
    it "returns Just for decimal digits (0-9)" $ do
      let decChars = ['0' .. '9']
      forM_ decChars $ \c ->
        fromDecDigit c `shouldBe` Just (digitToInt c {- HLINT ignore "Avoid restricted function" -})

    it "returns Nothing for non-decimal characters" $ do
      fromDecDigit 'a' `shouldBe` (Nothing :: Maybe Int)
      fromDecDigit 'A' `shouldBe` (Nothing :: Maybe Int)
      fromDecDigit 'g' `shouldBe` (Nothing :: Maybe Int)

  describe "fromOctDigit" $ do
    it "returns Just for octal digits (0-7)" $ do
      let octChars = ['0' .. '7']
      forM_ octChars $ \c ->
        fromOctDigit c `shouldBe` Just (digitToInt c {- HLINT ignore "Avoid restricted function" -})

    it "returns Nothing for 8, 9, and other characters" $ do
      fromOctDigit '8' `shouldBe` (Nothing :: Maybe Int)
      fromOctDigit '9' `shouldBe` (Nothing :: Maybe Int)
      fromOctDigit 'a' `shouldBe` (Nothing :: Maybe Int)
