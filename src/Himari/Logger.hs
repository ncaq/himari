-- | Logger utilities for Himari.
module Himari.Logger
  ( HasLogAction (..)
  , LogAction
  ) where

import Himari.Prelude

-- | ログ出力を行う能力があることを検査するための型クラス。
-- lensと互換性を持たせているので適切にフィールド名を設定してTemplate Haskellで生成すれば自動で実装されます。
class HasLogAction s a | s -> a where
  logAction :: Lens' s a

-- | ログ出力を行う関数の型。
-- 出力をカスタムしたい場合、このシグネチャに合わせた関数を作成するとやりやすい。
type LogAction = Loc -> LogSource -> LogLevel -> LogStr -> IO ()
