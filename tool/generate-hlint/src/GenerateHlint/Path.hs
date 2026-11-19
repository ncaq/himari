-- | プロジェクトの中のファイルの場所。
module GenerateHlint.Path
  ( dhallSourcePath
  , hlintYamlPath
  , findProjectRoot
  ) where

import Data.List qualified as L
import GenerateHlint.Exception
import Himari

-- | プロジェクトルートから見たDhallソースのエントリーポイント。
dhallSourcePath :: FilePath
dhallSourcePath = "hlint" </> "hlint.dhall"

-- | プロジェクトルートから見た生成先。
hlintYamlPath :: FilePath
hlintYamlPath = ".hlint.yaml"

-- | 指定したディレクトリから上に向かって、Dhallソースを持つプロジェクトルートを探します。
-- 近いディレクトリから順に調べて、最初に見つかったものを返します。
findProjectRoot :: (MonadIO m, MonadThrow m) => FilePath -> m FilePath
findProjectRoot start = foldr orParent (throwM $ ProjectRootNotFound start) (ancestors start)
 where
  orParent dir searchParent = do
    found <- doesFileExist (dir </> dhallSourcePath)
    if found then pure dir else searchParent

-- | 指定したディレクトリ自身と、ファイルシステムのルートまでの全ての親ディレクトリ。
-- 近いものから順に並びます。
ancestors :: FilePath -> [FilePath]
ancestors start = start : L.unfoldr parentOf start
 where
  parentOf dir =
    let parent = takeDirectory dir
     in if parent == dir then Nothing else Just (parent, parent)
