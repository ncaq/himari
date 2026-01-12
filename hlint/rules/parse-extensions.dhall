-- Language extensions for parsing
-- パースエラーを防ぐために有効化する言語拡張
let Types = ./../Types.dhall

in  [ Types.Rule.Arguments
        { arguments =
          [ "-XBlockArguments"
          , "-XCPP"
          , "-XOverloadedRecordDot"
          , "-XOverloadedRecordUpdate"
          , "-XQuasiQuotes"
          , "-XRecursiveDo"
          , "-XRecursiveDo"
          ]
        }
    ]
