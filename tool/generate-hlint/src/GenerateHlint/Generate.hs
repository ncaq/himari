-- | `.hlint.yaml`の内容の生成。
module GenerateHlint.Generate
  ( generate
  ) where

import GenerateHlint.Dhall
import GenerateHlint.Formatter
import GenerateHlint.Path
import GenerateHlint.Yaml
import Himari

-- | プロジェクトルートのDhallソースから`.hlint.yaml`の内容を生成します。
-- ファイルには書き込みません。
--
-- 2番目の引数はDhallのimportのキャッシュとして使うディレクトリです。
--
-- 整形した後の内容も読み直して、Dhallの評価結果と一致することを確かめます。
generate
  :: (MonadThrow m, MonadUnliftIO m) => Formatter m -> Maybe FilePath -> FilePath -> m ByteString
generate formatter dhallCache root = do
  rules <- evaluateRules dhallCache (root </> dhallSourcePath)
  rendered <- render rules
  formatted <- formatter (root </> hlintYamlPath) rendered
  verify rules formatted
