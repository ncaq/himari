-- hlint configuration
-- himariが推奨するスタイルを機械的にチェックするためのhlint設定ファイル
let Types = ./Types.dhall

let rules
    : List Types.Rule
    =   ./rules/groups.dhall
      # ./rules/aeson.dhall
      # ./rules/base.dhall
      # ./rules/bits.dhall
      # ./rules/bytestring.dhall
      # ./rules/char.dhall
      # ./rules/concurrency.dhall
      # ./rules/containers.dhall
      # ./rules/convertible.dhall
      # ./rules/exceptions.dhall
      # ./rules/lens.dhall
      # ./rules/mtl.dhall
      # ./rules/performance.dhall
      # ./rules/pretty-simple.dhall
      # ./rules/primitive.dhall
      # ./rules/qualified-imports.dhall
      # ./rules/safe.dhall
      # ./rules/string-io.dhall
      # ./rules/text.dhall
      # ./rules/typed-process.dhall
      # ./rules/unliftio.dhall
      # ./rules/unordered-containers.dhall
      # ./rules/unsafe.dhall
      # ./rules/vector.dhall

in  rules
