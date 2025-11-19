{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE NoFieldSelectors #-}

-- | 基本的な環境を提供するモジュール。
module Himari.Env.Simple
  ( SimpleEnv
  ) where

import Himari.Logger
import Himari.Prelude

-- | シンプルにロガーなどを持って解決するためのコンテキスト。
newtype SimpleEnv = SimpleEnv
  { logger :: Loc -> LogSource -> LogLevel -> LogStr -> IO ()
  -- ^ ログフレームワークに渡すための関数。
  }
  deriving (Generic)

makeFieldsId ''SimpleEnv
