-- | Dhallソースの評価。
module GenerateHlint.Dhall
  ( evaluateRules
  ) where

import Data.Text qualified as T
import Data.Text.Encoding.Error (UnicodeException)
import Data.Text.IO.Utf8 qualified as TO
import Dhall.Core qualified
import Dhall.Import qualified
import Dhall.JSON qualified
import Dhall.Parser qualified
import Dhall.TypeCheck qualified
import GenerateHlint.Exception
import Himari

-- | Dhallソースを評価してJSONの値にします。
-- `dhall-to-yaml`と同じく、`None`になったフィールドは出力から取り除きます。
--
-- 最初の引数はDhallのimportのキャッシュとして使うディレクトリです。
evaluateRules :: (MonadThrow m, MonadUnliftIO m) => Maybe FilePath -> FilePath -> m Value
evaluateRules dhallCache source = do
  exists <- doesFileExist source
  unless exists . throwM $ DhallSourceNotFound source
  code <-
    liftIO (TO.readFile source) `catch` \(err :: UnicodeException) ->
      throwM . DhallSourceNotUtf8 source . T.pack $ displayException err
  parsed <- either throwM pure $ Dhall.Parser.exprFromText source code
  resolved <- withImportStatus dhallCache (takeDirectory source) $ \status ->
    liftIO $ evalStateT (Dhall.Import.loadWith parsed) status
  -- `dhallToJSON`は型検査をしないので、変換の前に明示的に検査します。
  _ <- either throwM pure $ Dhall.TypeCheck.typeOf resolved
  value <- either throwM pure $ Dhall.JSON.dhallToJSON resolved
  pure $ Dhall.JSON.omitNull value

-- | importの解決方法を決めて処理を実行します。
--
-- キャッシュが指定されていない場合はDhallの通常の解決方法を使います。
--
-- キャッシュが指定されている場合は、
-- そのキャッシュだけでリモートのimportを解決します。
-- Dhallはハッシュ付きのimportをまずキャッシュから探すので、
-- キャッシュに当たる限りネットワークにはアクセスしません。
-- キャッシュに当たらなかった場合は通信を試みる代わりに、
-- 原因が分かる例外で失敗させます。
withImportStatus
  :: (MonadThrow m, MonadUnliftIO m)
  => Maybe FilePath
  -> FilePath
  -> (Dhall.Import.Status -> m a)
  -> m a
withImportStatus Nothing sourceDir action = action $ Dhall.Import.emptyStatus sourceDir
withImportStatus (Just cacheDir) sourceDir action = do
  exists <- doesDirectoryExist cacheDir
  unless exists . throwM $ DhallCacheNotFound cacheDir
  -- Dhallは書き込めないキャッシュディレクトリを無視します。
  -- Nixストアのような読み取り専用の場所を渡されても使えるように、
  -- 一時ディレクトリへコピーしてから使います。
  withSystemTempDirectory "generate-hlint-dhall-cache" $ \cacheHome -> do
    let writableCacheDir = cacheHome </> "dhall"
    createDirectoryIfMissing True writableCacheDir
    entries <- listDirectory cacheDir
    for_ entries $ \entry -> do
      isFile <- doesFileExist (cacheDir </> entry)
      when isFile $ copyFile (cacheDir </> entry) (writableCacheDir </> entry)
    withCacheHome cacheHome . action $
      (Dhall.Import.emptyStatus sourceDir)
        { Dhall.Import._remote = forbidRemote
        , Dhall.Import._remoteBytes = forbidRemote
        }
 where
  forbidRemote :: Dhall.Core.URL -> StateT Dhall.Import.Status IO a
  forbidRemote = throwM . RemoteImportNotCached . Dhall.Core.pretty

-- | Dhallがキャッシュを探す場所を一時的に差し替えます。
-- Dhallのライブラリはキャッシュの場所を環境変数からしか受け取らないため、
-- プロセスの環境変数を書き換えて、処理が終わったら元に戻します。
withCacheHome :: (MonadUnliftIO m) => FilePath -> m a -> m a
withCacheHome cacheHome =
  bracket
    (lookupEnv xdgCacheHome <* setEnv xdgCacheHome cacheHome)
    (maybe (unsetEnv xdgCacheHome) (setEnv xdgCacheHome))
    . const
 where
  xdgCacheHome = "XDG_CACHE_HOME"
