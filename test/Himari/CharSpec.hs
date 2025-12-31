module Himari.CharSpec (spec) where

import Data.Char (intToDigit)
import Himari
import Test.QuickCheck
import Test.Syd

spec :: Spec
spec = do
  describe "intToDigitMay" $ do
    describe "boundary values" $ do
      it "returns Just '0' for 0" $ do
        intToDigitMay 0 `shouldBe` Just '0'

      it "returns Just 'f' for 15" $ do
        intToDigitMay 15 `shouldBe` Just 'f'

      it "returns Nothing for -1" $ do
        intToDigitMay (-1) `shouldBe` Nothing

      it "returns Nothing for 16" $ do
        intToDigitMay 16 `shouldBe` Nothing

    describe "all valid values (0-15)" $ do
      it "returns Just for all values in range" $ do
        let validRange = [0 .. 15]
        forM_ validRange $ \n ->
          intToDigitMay n `shouldSatisfy` isJust

      it "matches intToDigit for all valid values" $ do
        let validRange = [0 .. 15]
        forM_ validRange $ \n ->
          intToDigitMay n `shouldBe` Just (intToDigit n {- HLINT ignore "Avoid restricted function" -})

    describe "QuickCheck properties" $ do
      it "returns Just for values in range 0-15" $ do
        property . forAll (choose (0, 15)) $ \n ->
          isJust (intToDigitMay n)

      it "returns Nothing for negative values" $ do
        property . forAll (choose (-1000, -1)) $ \n ->
          isNothing (intToDigitMay n)

      it "returns Nothing for values greater than 15" $ do
        property . forAll (choose (16, 1000)) $ \n ->
          isNothing (intToDigitMay n)

      it "matches intToDigit for all valid inputs" $ do
        property . forAll (choose (0, 15)) $ \n ->
          intToDigitMay n == Just (intToDigit n {- HLINT ignore "Avoid restricted function" -})

      it "produces lowercase hex digits for 10-15" $ do
        property . forAll (choose (10, 15)) $ \n ->
          case intToDigitMay n of
            Just c -> c `elem` ['a' .. 'f']
            Nothing -> False

      it "produces decimal digits for 0-9" $ do
        property . forAll (choose (0, 9)) $ \n ->
          case intToDigitMay n of
            Just c -> c `elem` ['0' .. '9']
            Nothing -> False
