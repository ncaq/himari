-- | 既存の`.hlint.yaml`の検査。
module GenerateHlint.Check
  ( check
  ) where

import Data.Algorithm.Diff (getGroupedDiff)
import Data.Algorithm.DiffOutput (ppDiff)
import Data.ByteString qualified as B
import Data.Text qualified as T
import Data.Text.Encoding qualified as TE
import GenerateHlint.Exception
import GenerateHlint.Formatter
import GenerateHlint.Generate
import GenerateHlint.Path
import Himari

-- | プロジェクトルートの`.hlint.yaml`が生成結果と一致することを検査します。
-- 一致しない場合は差分を持った`HlintYamlOutOfDate`を送出します。
check :: (MonadThrow m, MonadUnliftIO m) => Formatter m -> Maybe FilePath -> FilePath -> m ()
check formatter dhallCache root = do
  let path = root </> hlintYamlPath
  exists <- doesFileExist path
  unless exists . throwM $ HlintYamlNotFound path
  generated <- generate formatter dhallCache root
  committed <- liftIO $ B.readFile path
  unless (committed == generated) . throwM $
    HlintYamlOutOfDate path (diffText committed generated)

-- | 行単位の差分を人間が読める形にします。
diffText :: ByteString -> ByteString -> Text
diffText old new = T.pack . ppDiff $ getGroupedDiff (toLines old) (toLines new)
 where
  toLines = fmap T.unpack . T.lines . TE.decodeUtf8Lenient
