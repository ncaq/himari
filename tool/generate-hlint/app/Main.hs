-- | Dhallソースから`.hlint.yaml`を生成・検査するコマンド。
module Main (main) where

import Data.Text qualified as T
import GenerateHlint
import Himari
import Options.Applicative qualified as O

optionsParser :: O.Parser Options
optionsParser = do
  projectRoot <-
    optional . O.strOption $
      O.long "project-root"
        <> O.metavar "DIR"
        <> O.help
          ( "Project root that contains hlint/hlint.dhall."
              <> " Searched upward from the current directory by default."
          )
  dhallCache <-
    optional . O.strOption $
      O.long "dhall-cache"
        <> O.metavar "DIR"
        <> O.help
          ( "Directory of Dhall import cache files."
              <> " When given, remote imports are resolved only from it"
              <> " and the network is never accessed."
          )
  checkOnly <-
    O.switch $
      O.long "check"
        <> O.help "Do not write. Fail if .hlint.yaml differs from the generated one."
  pure Options{..}

parserInfo :: O.ParserInfo Options
parserInfo =
  O.info (optionsParser <**> O.helper) $
    O.fullDesc <> O.progDesc "Generate .hlint.yaml of himari from the Dhall sources"

-- | 失敗の内容をエラーログとして標準エラー出力に書いて異常終了します。
-- メッセージには日本語が含まれますが、
-- ロガーはUTF-8のバイト列として書き出すので、
-- ロケールに依存した文字コード変換で失敗することはありません。
main :: IO ()
main = do
  options <- O.execParser parserInfo
  run options `catchAny` \exception -> do
    runSimpleEnv . logErrorN . T.pack $ displayException exception
    throwM $ ExitFailure 1
