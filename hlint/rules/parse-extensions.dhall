-- Language extensions for parsing
-- パースエラーを防ぐために有効化する言語拡張
-- cabalのdefault-extensionsと同期させる
let Types = ./../Types.dhall

in  [ Types.Rule.Arguments
        { arguments =
          [ "-XGHC2024"
          , "-XApplicativeDo"
          , "-XBlockArguments"
          , "-XCPP"
          , "-XDefaultSignatures"
          , "-XDerivingVia"
          , "-XDuplicateRecordFields"
          , "-XFunctionalDependencies"
          , "-XLexicalNegation"
          , "-XLinearTypes"
          , "-XMonadComprehensions"
          , "-XMultiWayIf"
          , "-XNegativeLiterals"
          , "-XNoFieldSelectors"
          , "-XNoImplicitPrelude"
          , "-XOverloadedLabels"
          , "-XOverloadedRecordDot"
          , "-XOverloadedRecordUpdate"
          , "-XOverloadedStrings"
          , "-XParallelListComp"
          , "-XPatternSynonyms"
          , "-XQualifiedDo"
          , "-XQuantifiedConstraints"
          , "-XQuasiQuotes"
          , "-XRecordWildCards"
          , "-XRecursiveDo"
          , "-XStrictData"
          , "-XTemplateHaskell"
          , "-XTypeData"
          , "-XTypeFamilies"
          , "-XTypeFamilyDependencies"
          , "-XViewPatterns"
          ]
        }
    ]
