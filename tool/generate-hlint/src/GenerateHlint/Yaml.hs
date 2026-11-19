-- | 評価結果のYAMLへの書き出し。
module GenerateHlint.Yaml
  ( header
  , render
  , verify
  ) where

import Data.Text qualified as T
import Data.Text.Encoding qualified as TE
import Data.Yaml qualified as Yaml
import GenerateHlint.Exception
import Himari

-- | 生成するファイルの先頭に付けるコメント。
header :: Text
header =
  T.unlines
    [ "# himari hlint configuration"
    , "#"
    , "# このファイルはDhallによって自動生成されています。"
    , "# 直接編集しないでください。"
    , "#"
    , "# himariが推奨するスタイルを機械的にチェックするためのhlint設定ファイルです。"
    , "# 部分関数や危険な関数の使用を警告したり、"
    , "# より可読性の高いパターンを提案します。"
    , "#"
    , "# 使い方:"
    , "#   * このファイルをプロジェクトルートに .hlint.yaml としてコピー"
    , "#   * または .hlint.yaml から参照: - arguments: [--hint=path/to/this/.hlint.yaml]"
    ]

-- | 評価結果をコメント付きのYAMLにします。
--
-- YAMLの書き出しにはlibyamlを使います。
-- `dhall-to-yaml`が使っている`aeson-yaml`は`a: b`のような文字列をクォートせず、
-- 壊れたYAMLを書き出すことがあるためです。
-- 長いメッセージが途中で折り返されないように行の幅は無制限にします。
--
-- 出力したYAMLは`verify`で確かめてから返します。
-- 見た目は後段のフォーマッターが整えます。
render :: (MonadThrow m) => Value -> m ByteString
render rules = do
  case rules of
    Array _ -> pure ()
    _ -> throwM RulesNotList
  let format = Yaml.setWidth Nothing Yaml.defaultFormatOptions
      encodeOptions = Yaml.setFormat format Yaml.defaultEncodeOptions
  verify rules $ TE.encodeUtf8 header <> Yaml.encodeWith encodeOptions rules

-- | YAMLを読み直して、元の値と一致する場合だけそのまま返します。
-- クォートの漏れや整形の不具合で意味の変わったYAMLを書き出してしまうことを防ぎます。
verify :: (MonadThrow m) => Value -> ByteString -> m ByteString
verify rules output = case Yaml.decodeEither' output of
  Left err -> throwM . GeneratedYamlUnreadable . T.pack $ Yaml.prettyPrintParseException err
  Right reread
    | reread == rules -> pure output
    | otherwise -> throwM GeneratedYamlChanged
