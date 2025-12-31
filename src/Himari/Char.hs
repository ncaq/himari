-- | Safe alternatives to partial functions from "Data.Char".
module Himari.Char
  ( intToDigitMay
  ) where

import Data.Bool (otherwise, (&&))
import Data.Char (Char, intToDigit)
import Data.Int (Int)
import Data.Maybe (Maybe (..))
import Data.Ord ((<=))

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
