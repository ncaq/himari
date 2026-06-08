{-# LANGUAGE Safe #-}
{-# LANGUAGE NoGeneralizedNewtypeDeriving #-}

-- | Logger utilities for Himari.
module Himari.Logger
  ( HasLogAction (..)
  , LogAction
  , defaultMonadLoggerLog
  , defaultLogAction
  , discardLogAction
  ) where

import Himari.Env
import Himari.SafePrelude
import System.IO (stderr)

-- | ログ出力を行う能力があることを検査するための型クラス。
-- lensと互換性を持たせているので適切にフィールド名を設定して、
-- Template Haskellで生成すれば自動で実装されます。
class HasLogAction s a | s -> a where
  logAction :: Lens' s a

-- | ログ出力を行う関数の型。
-- 出力をカスタムしたい場合、このシグネチャに合わせた関数を作成するとやりやすい。
type LogAction = Loc -> LogSource -> LogLevel -> LogStr -> IO ()

-- | "MonadLogger".'monadLoggerLog'に渡せるデフォルトの実装。
defaultMonadLoggerLog
  :: (HasLogAction env LogAction, ToLogStr msg)
  => Loc -> LogSource -> LogLevel -> msg -> Himari env ()
defaultMonadLoggerLog loc src level msg = do
  logAction' <- view logAction
  liftIO . logAction' loc src level $ toLogStr msg

-- | デフォルトのログ出力。
-- 標準エラー出力にログを出力します。
defaultLogAction :: LogAction
defaultLogAction = defaultOutput stderr

-- | ログを一切出力せず破棄するログ出力。
-- テストなどで実際のターミナルにログを出力したくない場合に使えます。
discardLogAction :: LogAction
discardLogAction _loc _src _level _msg = pure ()
