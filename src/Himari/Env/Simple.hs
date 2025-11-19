{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE NoFieldSelectors #-}

-- | 基本的な環境を提供するモジュール。
module Himari.Env.Simple
  ( SimpleEnv
  , runSimpleEnv
  , runSimpleEnvWith
  ) where

import Himari.Env
import Himari.Logger
import Himari.Prelude

-- | シンプルにロガーなどを持って解決するためのコンテキスト。
newtype SimpleEnv = SimpleEnv
  { logAction :: LogAction
  -- ^ ログフレームワークに渡すための関数。
  -- デフォルトではmonad-loggerによって標準エラー出力にログを出力する。
  }
  deriving (Generic)

makeFieldsId ''SimpleEnv

instance MonadLogger (Himari SimpleEnv) where
  monadLoggerLog loc src level msg = do
    logAction' <- view logAction
    liftIO $ logAction' loc src level (toLogStr msg)

-- | `SimpleEnv`をデフォルト設定で実行する。
runSimpleEnv :: (MonadIO m) => Himari SimpleEnv a -> m a
runSimpleEnv = runSimpleEnvWith $ defaultOutput stderr

-- | `SimpleEnv`をカスタム出力で実行する。
runSimpleEnvWith
  :: (MonadIO m) => LogAction -> Himari SimpleEnv a -> m a
runSimpleEnvWith logAction' action = do
  runHimari (SimpleEnv logAction') action
