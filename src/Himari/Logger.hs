{-# LANGUAGE FunctionalDependencies #-}

module Himari.Logger
  ( HasLogAction (..)
  , LogAction
  ) where

import Himari.Prelude

class HasLogAction s a | s -> a where
  logAction :: Lens' s a

-- | ログ出力を行う関数の型。
-- 出力をカスタムしたい場合、このシグネチャに合わせた関数を作成するとやりやすい。
type LogAction = Loc -> LogSource -> LogLevel -> LogStr -> IO ()
