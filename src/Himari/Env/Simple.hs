{-# LANGUAGE Trustworthy #-}

-- | 基本的な環境を提供するモジュール。
-- 単純に実行だけをしたい場合、これで十分結果を手に入れられることが多いです。
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
    liftIO . logAction' loc src level $ toLogStr msg

-- | `SimpleEnv`をデフォルト設定で実行する。
runSimpleEnv :: (MonadIO m) => Himari SimpleEnv a -> m a
runSimpleEnv = runSimpleEnvWith $ defaultOutput stderr

-- | `SimpleEnv`をカスタム出力で実行します。
runSimpleEnvWith
  :: (MonadIO m)
  => LogAction
  -- ^ ログの出力方法。例えば`defaultOutput stdout`にすれば標準出力にログが出力されます。
  -> Himari SimpleEnv a
  -- ^ 実行したいアクション。
  -> m a
runSimpleEnvWith logAction' = runHimari (SimpleEnv logAction')
