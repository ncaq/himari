-- Language extensions enabled by default for parsing
-- パースエラーを防ぐために有効化する言語拡張
let Builder = ./../Builder.dhall

let Types = ./../Types.dhall

in  [ Builder.extensions
        [ Builder.extensionNames
            [ "BlockArguments"
            , "CPP"
            , "OverloadedRecordDot"
            , "OverloadedRecordUpdate"
            , "QuasiQuotes"
            , "RecursiveDo"
            , "TemplateHaskell"
            ]
        ]
    ]
