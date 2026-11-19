-- | Dhallソースから`.hlint.yaml`を生成・検査するコマンドの入口。
--
-- 生成の流れは全てこのパッケージの中で完結させています。
-- シェルスクリプトや外部コマンドを繋ぎ合わせると、
-- 途中の失敗を見落としやすく、
-- 環境によって結果が変わりやすいためです。
module GenerateHlint
  ( Options (..)
  , run
  , runWith
  ) where

import GHC.IO.Encoding (setLocaleEncoding, utf8)
import GenerateHlint.Check
import GenerateHlint.Formatter
import GenerateHlint.Generate
import GenerateHlint.Path
import Himari

-- | コマンドラインから受け取る設定。
data Options = Options
  { projectRoot :: Maybe FilePath
  -- ^ プロジェクトルート。
  -- 指定しない場合はカレントディレクトリから上に向かって探します。
  , dhallCache :: Maybe FilePath
  -- ^ Dhallのimportのキャッシュとして使うディレクトリ。
  -- 指定した場合はリモートのimportをこのキャッシュだけで解決し、
  -- ネットワークには一切アクセスしません。
  , checkOnly :: Bool
  -- ^ 書き込まずに、既存の`.hlint.yaml`が生成結果と一致するかだけを検査します。
  }
  deriving stock (Eq, Generic, Show)

-- | 設定に従って生成または検査を行います。
-- 失敗は例外として送出します。
--
-- 処理の前提として、プロセスのロケールの文字コードをUTF-8に固定します。
-- Dhallのライブラリはimportしたファイルをロケールの文字コードで読むので、
-- Nixのサンドボックスの中のようにロケールがUTF-8ではない環境では、
-- 日本語のコメントを含むDhallソースを読めないためです。
run :: (MonadThrow m, MonadUnliftIO m) => Options -> m ()
run = runWith treefmt

-- | 整形の方法を指定して`run`と同じ処理を行います。
-- treefmtが無い環境でも生成と検査の流れをテストできるように分けています。
runWith :: (MonadThrow m, MonadUnliftIO m) => Formatter m -> Options -> m ()
runWith formatter options = do
  liftIO $ setLocaleEncoding utf8
  -- 以降の処理やフォーマッターが作業ディレクトリに左右されないように絶対パスにします。
  root <- makeAbsolute =<< maybe (getCurrentDirectory >>= findProjectRoot) pure options.projectRoot
  if options.checkOnly
    then check formatter options.dhallCache root
    else do
      generated <- generate formatter options.dhallCache root
      writeBinaryFileDurableAtomic (root </> hlintYamlPath) generated
