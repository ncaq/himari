-- | Safe alternatives to partial functions from "Data.Char".
module Himari.Char
  ( digitToIntMay
  , intToDigitMay
  , chrMay
  ) where

import Data.Char qualified as C
import Himari.Prelude

-- | Safe version of 'digitToInt'.
--
-- Converts a hexadecimal digit character to the corresponding 'Int' value.
-- Accepts decimal digits (@\'0\'@-@\'9\'@), lowercase hex digits (@\'a\'@-@\'f\'@),
-- and uppercase hex digits (@\'A\'@-@\'F\'@).
--
-- Returns 'Nothing' for characters outside the valid range,
-- instead of throwing an exception like 'digitToInt'.
--
-- >>> digitToIntMay '0'
-- Just 0
-- >>> digitToIntMay '9'
-- Just 9
-- >>> digitToIntMay 'a'
-- Just 10
-- >>> digitToIntMay 'F'
-- Just 15
-- >>> digitToIntMay 'g'
-- Nothing
-- >>> digitToIntMay ' '
-- Nothing
digitToIntMay :: C.Char -> Maybe Int
digitToIntMay c
  | C.isHexDigit c = Just (C.digitToInt c {- HLINT ignore "Avoid restricted function" -})
  | otherwise = Nothing

-- | Safe version of 'intToDigit'.
--
-- Converts an 'Int' in the range 0..15 to the corresponding
-- single hexadecimal digit 'Char' (using lowercase 'a'-'f' for 10-15).
--
-- Returns 'Nothing' for values outside the valid range,
-- instead of throwing an exception like 'intToDigit'.
--
-- >>> intToDigitMay 0
-- Just '0'
-- >>> intToDigitMay 10
-- Just 'a'
-- >>> intToDigitMay 15
-- Just 'f'
-- >>> intToDigitMay (-1)
-- Nothing
-- >>> intToDigitMay 16
-- Nothing
intToDigitMay :: Int -> Maybe C.Char
intToDigitMay n
  | 0 <= n && n <= 15 = Just (C.intToDigit n {- HLINT ignore "Avoid restricted function" -})
  | otherwise = Nothing

-- | Safe version of 'chr'.
--
-- Converts an 'Int' to a Unicode 'Char'.
-- Valid code points are 0 to 0x10FFFF, excluding the surrogate range
-- 0xD800 to 0xDFFF.
--
-- Returns 'Nothing' for invalid code points,
-- instead of throwing an exception like 'chr'.
--
-- >>> chrMay 65
-- Just 'A'
-- >>> chrMay 0x3042
-- Just '\12354'
-- >>> chrMay 0x10FFFF
-- Just '\1114111'
-- >>> chrMay (-1)
-- Nothing
-- >>> chrMay 0x110000
-- Nothing
-- >>> chrMay 0xD800
-- Nothing
-- >>> chrMay 0xDFFF
-- Nothing
chrMay :: Int -> Maybe C.Char
chrMay n
  | n >= 0 && n <= 0x10FFFF && not (n >= 0xD800 && n <= 0xDFFF) =
      Just (C.chr n {- HLINT ignore "Avoid restricted function" -})
  | otherwise = Nothing
