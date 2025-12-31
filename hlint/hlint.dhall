-- hlint configuration
-- himariが推奨するスタイルを機械的にチェックするためのhlint設定ファイル
let Types = ./Types.dhall

let rules
    : List Types.Rule
    =   ./rules/groups.dhall
      # ./rules/aeson.dhall
      # ./rules/bits.dhall
      # ./rules/bytestring.dhall
      # ./rules/concurrency.dhall
      # ./rules/containers.dhall
      # ./rules/convertible.dhall
      # ./rules/exceptions.dhall
      # ./rules/partial.dhall
      # ./rules/performance.dhall
      # ./rules/qualified-imports.dhall
      # ./rules/safe.dhall
      # ./rules/string-io.dhall
      # ./rules/text.dhall
      # ./rules/typed-process.dhall
      # ./rules/unliftio.dhall
      # ./rules/unsafe.dhall
      # ./rules/vector.dhall

in  rules
