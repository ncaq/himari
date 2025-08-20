module Himari.Title where

import Data.List.NonEmpty qualified as NE
import Data.Text qualified as T
import Data.Text.IO qualified as T
import Himari

-- | ヒマリの肩書き要素。
-- 順番は固定。
-- `NonEmpty`で表現することで、最低1つは要素があることを保証。
titleComponents :: NonEmpty Text
titleComponents = "超" NE.:| ["天才", "清楚系", "病弱", "美少女", "ハッカー"]

-- | 全ての組み合わせを生成。
-- `NonEmpty`の部分列を生成。
generateAllCombinations :: [NonEmpty Text]
generateAllCombinations = nonEmptySubsequences titleComponents
 where
  -- NonEmptyの空でない部分列を全て生成（順番は保持）
  nonEmptySubsequences :: NonEmpty a -> [NonEmpty a]
  nonEmptySubsequences (x NE.:| []) = [x NE.:| []]
  nonEmptySubsequences (x NE.:| (y : ys)) =
    let rest = nonEmptySubsequences (y NE.:| ys)
     in rest ++ map (x NE.<|) rest ++ [x NE.:| []]

-- | 肩書きを`Text`に変換。
renderTitle :: NonEmpty Text -> Text
renderTitle = T.concat . NE.toList

-- | 明示的に標準入出力に一行ずつ名乗りを出力。
printAllTitle :: IO ()
printAllTitle = mapM_ (T.putStrLn . renderTitle) generateAllCombinations
