-- | Safe alternatives to partial functions from "Data.Char".
module Himari.Char
  ( digitToIntMay
  , intToDigitMay
  ) where

import Data.Char (digitToInt, intToDigit, isHexDigit)
import Prelude

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
digitToIntMay :: Char -> Maybe Int
digitToIntMay c
  | isHexDigit c = Just (digitToInt c {- HLINT ignore "Avoid restricted function" -})
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
intToDigitMay :: Int -> Maybe Char
intToDigitMay n
  | 0 <= n && n <= 15 = Just (intToDigit n {- HLINT ignore "Avoid restricted function" -})
  | otherwise = Nothing
