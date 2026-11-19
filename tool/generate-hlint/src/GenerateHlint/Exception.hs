-- | `.hlint.yaml`の生成・検査で起きる失敗の定義。
module GenerateHlint.Exception
  ( GenerateHlintException (..)
  ) where

import Data.Text qualified as T
import Himari

-- | このツールが原因を説明できる失敗。
data GenerateHlintException
  = -- | プロジェクトルートが見つからなかった。探索を始めたディレクトリを持ちます。
    ProjectRootNotFound FilePath
  | -- | Dhallソースが見つからなかった。
    DhallSourceNotFound FilePath
  | -- | Dhallソースの文字コードがUTF-8ではなかった。
    DhallSourceNotUtf8 FilePath Text
  | -- | 指定されたDhallのキャッシュがディレクトリではなかった。
    DhallCacheNotFound FilePath
  | -- | キャッシュに無いリモートのimportを解決しようとした。URLを持ちます。
    RemoteImportNotCached Text
  | -- | Dhallの評価結果がhlintの設定として期待するリストではなかった。
    RulesNotList
  | -- | 生成したYAMLを読み直せなかった。
    GeneratedYamlUnreadable Text
  | -- | 生成したYAMLを読み直した結果が元の値と一致しなかった。
    GeneratedYamlChanged
  | -- | フォーマッターを起動できなかった。
    FormatterNotStarted Text
  | -- | フォーマッターが失敗した。終了コードと標準エラー出力を持ちます。
    FormatterFailed Int Text
  | -- | 検査対象の`.hlint.yaml`が存在しなかった。
    HlintYamlNotFound FilePath
  | -- | `.hlint.yaml`が生成結果と一致しなかった。差分を持ちます。
    HlintYamlOutOfDate FilePath Text
  deriving stock (Eq, Generic, Show)

instance Exception GenerateHlintException where
  displayException = T.unpack . message

-- | 失敗の原因と対処を人間に説明する文章。
message :: GenerateHlintException -> Text
message = \case
  ProjectRootNotFound start ->
    "hlint/hlint.dhallを持つプロジェクトルートが見つかりませんでした。探索開始地点: "
      <> T.pack start
      <> "\n--project-rootで明示的に指定することもできます。"
  DhallSourceNotFound path ->
    "Dhallソースが見つかりません: " <> T.pack path
  DhallSourceNotUtf8 path reason ->
    "DhallソースがUTF-8として読めません: " <> T.pack path <> "\n" <> reason
  DhallCacheNotFound path ->
    "Dhallのキャッシュとして指定されたディレクトリが見つかりません: " <> T.pack path
  RemoteImportNotCached url ->
    "リモートのimportがDhallのキャッシュにありません: "
      <> url
      <> "\nネットワークにはアクセスしない設定で実行されています。"
      <> "\nimportのバージョンとハッシュが、"
      <> "キャッシュとして渡しているパッケージ(nixpkgsのdhallPackages.Preludeなど)"
      <> "と一致しているか確認してください。"
  RulesNotList ->
    "Dhallの評価結果がリストではありません。hlintの設定はルールのリストである必要があります。"
  GeneratedYamlUnreadable reason ->
    "生成したYAMLを読み直せませんでした。YAMLの出力か整形の処理に問題があります。\n" <> reason
  GeneratedYamlChanged ->
    "生成したYAMLを読み直した結果が元の値と一致しません。YAMLの出力か整形の処理に問題があります。"
  FormatterNotStarted reason ->
    "treefmtを起動できませんでした。PATHにtreefmtがあるか確認してください。\n" <> reason
  FormatterFailed code output ->
    "treefmtが終了コード" <> T.pack (show code) <> "で失敗しました。\n" <> output
  HlintYamlNotFound path ->
    "検査対象のファイルが見つかりません: " <> T.pack path <> "\n" <> regenerateHint
  HlintYamlOutOfDate path difference ->
    T.pack path
      <> "がDhallソースから生成したものと一致しません。\n"
      <> regenerateHint
      <> "\n差分(<が現在のファイル、>が生成結果):\n"
      <> difference

-- | 再生成の方法の案内。
regenerateHint :: Text
regenerateHint = "nix run '.#generate-hlint'を実行して再生成してください。"
