-- このテストモジュール自体が避けるべき関数のラッパーを作れているか検査するため、
-- 避けるべき関数を呼び出して振る舞いの互換性の検査などを行う必要があります。
{- HLINT ignore "Avoid restricted function"  -}
module Himari.CharSpec (spec) where

import Data.Char (chr, digitToInt, intToDigit, isHexDigit, ord, toUpper)
import Himari hiding (elements)
import Test.QuickCheck
import Test.Syd

spec :: Spec
spec = do
  describe "digitToIntMay" $ do
    describe "boundary values" $ do
      it "returns Just 0 for '0'" $ do
        digitToIntMay '0' `shouldBe` Just 0

      it "returns Just 9 for '9'" $ do
        digitToIntMay '9' `shouldBe` Just 9

      it "returns Just 10 for 'a'" $ do
        digitToIntMay 'a' `shouldBe` Just 10

      it "returns Just 10 for 'A'" $ do
        digitToIntMay 'A' `shouldBe` Just 10

      it "returns Just 15 for 'f'" $ do
        digitToIntMay 'f' `shouldBe` Just 15

      it "returns Just 15 for 'F'" $ do
        digitToIntMay 'F' `shouldBe` Just 15

      it "returns Nothing for 'g'" $ do
        digitToIntMay 'g' `shouldBe` Nothing

      it "returns Nothing for 'G'" $ do
        digitToIntMay 'G' `shouldBe` Nothing

      it "returns Nothing for ' '" $ do
        digitToIntMay ' ' `shouldBe` Nothing

    describe "all valid hex digits" $ do
      it "returns Just for all decimal digits" $ do
        forM_ ['0' .. '9'] $ \c ->
          digitToIntMay c `shouldSatisfy` isJust

      it "returns Just for all lowercase hex letters" $ do
        forM_ ['a' .. 'f'] $ \c ->
          digitToIntMay c `shouldSatisfy` isJust

      it "returns Just for all uppercase hex letters" $ do
        forM_ ['A' .. 'F'] $ \c ->
          digitToIntMay c `shouldSatisfy` isJust

      it "matches digitToInt for all valid characters" $ do
        let validChars = ['0' .. '9'] <> ['a' .. 'f'] <> ['A' .. 'F']
        forM_ validChars $ \c ->
          digitToIntMay c `shouldBe` Just (digitToInt c)

    describe "QuickCheck properties" $ do
      it "returns Just for hex digit characters" $ do
        property . forAll (elements (['0' .. '9'] <> ['a' .. 'f'] <> ['A' .. 'F'])) $ \c ->
          isJust (digitToIntMay c)

      it "returns Nothing for non-hex characters" $ do
        property . forAll (elements (['g' .. 'z'] <> ['G' .. 'Z'] <> [' ', '!', '@', '#'])) $ \c ->
          isNothing (digitToIntMay c)

      it "matches digitToInt for all valid hex digit inputs" $ do
        property . forAll (elements (['0' .. '9'] <> ['a' .. 'f'] <> ['A' .. 'F'])) $ \c ->
          digitToIntMay c == Just (digitToInt c)

      it "agrees with isHexDigit on validity" $ do
        property $ \c ->
          isJust (digitToIntMay c) == isHexDigit c

      it "returns values in range 0-15 for valid inputs" $ do
        property . forAll (elements (['0' .. '9'] <> ['a' .. 'f'] <> ['A' .. 'F'])) $ \c ->
          case digitToIntMay c of
            Just n -> n >= 0 && n <= 15
            Nothing -> False

      it "lowercase and uppercase give same result" $ do
        property . forAll (elements ['a' .. 'f']) $ \c ->
          digitToIntMay c == digitToIntMay (toUpper c)

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
          intToDigitMay n `shouldBe` Just (intToDigit n)

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
          intToDigitMay n == Just (intToDigit n)

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

  describe "chrMay" $ do
    describe "boundary values" $ do
      it "returns Just for 0 (NUL)" $ do
        chrMay 0 `shouldBe` Just '\0'

      it "returns Just 'A' for 65" $ do
        chrMay 65 `shouldBe` Just 'A'

      it "returns Just for max valid code point (0x10FFFF)" $ do
        chrMay 0x10FFFF `shouldBe` Just '\x10FFFF'

      it "returns Nothing for -1" $ do
        chrMay (-1) `shouldBe` Nothing

      it "returns Nothing for 0x110000 (beyond max)" $ do
        chrMay 0x110000 `shouldBe` Nothing

      it "returns Nothing for surrogate start (0xD800)" $ do
        chrMay 0xD800 `shouldBe` Nothing

      it "returns Nothing for surrogate end (0xDFFF)" $ do
        chrMay 0xDFFF `shouldBe` Nothing

      it "returns Nothing for surrogate middle (0xDC00)" $ do
        chrMay 0xDC00 `shouldBe` Nothing

    describe "valid ranges" $ do
      it "returns Just for code points before surrogate range" $ do
        chrMay 0xD7FF `shouldSatisfy` isJust

      it "returns Just for code points after surrogate range" $ do
        chrMay 0xE000 `shouldSatisfy` isJust

      it "returns Just for common characters" $ do
        forM_ [('a', 97), ('z', 122), ('0', 48), ('9', 57)] $ \(expected, n) ->
          chrMay n `shouldBe` Just expected

    describe "QuickCheck properties" $ do
      it "returns Just for valid BMP code points (excluding surrogates)" $ do
        property . forAll (choose (0, 0xD7FF)) $ \n ->
          isJust (chrMay n)

      it "returns Just for valid code points after surrogates" $ do
        property . forAll (choose (0xE000, 0x10FFFF)) $ \n ->
          isJust (chrMay n)

      it "returns Nothing for surrogate range" $ do
        property . forAll (choose (0xD800, 0xDFFF)) $ \n ->
          isNothing (chrMay n)

      it "returns Nothing for negative values" $ do
        property . forAll (choose (-1000, -1)) $ \n ->
          isNothing (chrMay n)

      it "returns Nothing for values beyond max code point" $ do
        property . forAll (choose (0x110000, 0x200000)) $ \n ->
          isNothing (chrMay n)

      it "matches chr for all valid inputs" $ do
        property . forAll (choose (0, 0xD7FF)) $ \n ->
          chrMay n == Just (chr n)

      it "is inverse of ord for valid characters" $ do
        property $ \c ->
          chrMay (ord c) == Just c

      it "never throws an exception for any Int value" $ do
        withNumTests 10000 . property $ \n ->
          case chrMay n of
            Just _ -> True
            Nothing -> True

#if !MIN_VERSION_QuickCheck(2,18,0)
-- | `withNumTests`は`QuickCheck 2.18.0.0`で、
-- `withMaxSuccess`から改名された関数です。
-- それより古いQuickCheckには存在しないため、
-- `withMaxSuccess`で互換定義します。
withNumTests :: (Testable prop) => Int -> prop -> Property
withNumTests = withMaxSuccess
#endif
