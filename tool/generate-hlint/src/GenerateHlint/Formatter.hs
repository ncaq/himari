-- | 生成したYAMLの整形。
module GenerateHlint.Formatter
  ( Formatter
  , treefmt
  , treefmtWith
  ) where

import Data.ByteString.Lazy qualified as BL
import Data.Text qualified as T
import Data.Text.Encoding qualified as TE
import GenerateHlint.Exception
import Himari

-- | 書き出し先のパスと内容を受け取って、整形した内容を返す処理。
-- ファイルには書き込まないものを渡してください。
type Formatter m = FilePath -> ByteString -> m ByteString

-- | プロジェクトのtreefmt(`nix fmt`の実体)で整形します。
--
-- `.hlint.yaml`はリポジトリに含めるので、
-- `nix fmt`を実行しても変化しない内容で生成する必要があります。
-- 特定のフォーマッターを直接呼び出すと、
-- treefmtの設定を変えた時に生成結果と`nix fmt`の結果が食い違うので、
-- treefmtそのものに整形を任せます。
--
-- 標準入力で内容を渡すので、作業ツリーのファイルは変更されません。
-- キャッシュはサンドボックスの中など書き込めない環境でも動くように使いません。
treefmt :: (MonadThrow m, MonadUnliftIO m) => Formatter m
treefmt = treefmtWith "treefmt"

-- | treefmtとして起動するコマンドを指定して`treefmt`と同じ処理を行います。
-- 起動や整形に失敗した場合の扱いをテストできるように分けています。
treefmtWith :: (MonadThrow m, MonadUnliftIO m) => FilePath -> Formatter m
treefmtWith command path content = do
  -- treefmtはカレントディレクトリから上に向かってプロジェクトルートを探すので、
  -- どこから実行されても見つけられるように書き出し先のディレクトリで起動します。
  let config =
        setWorkingDir (takeDirectory path)
          . setStdin (byteStringInput (BL.fromStrict content))
          $ proc command ["--no-cache", "--stdin", path]
  (exitCode, formatted, errorOutput) <-
    readProcess config `catchIO` (throwM . FormatterNotStarted . T.pack . displayException)
  case exitCode of
    ExitSuccess -> pure $ BL.toStrict formatted
    ExitFailure code ->
      throwM . FormatterFailed code . TE.decodeUtf8Lenient $ BL.toStrict errorOutput
