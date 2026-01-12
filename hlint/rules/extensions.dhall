-- Rules for language extension restrictions
-- 危険な言語拡張と非推奨の言語拡張に対する警告ルール
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let dangerousExtensions
    : List Text
    = [ "AllowAmbiguousTypes"
      , "DeferTypeErrors"
      , "ExtendedDefaultRules"
      , "ImpredicativeTypes"
      , "IncoherentInstances"
      , "LiberalTypeSynonyms"
      , "OverlappingInstances"
      , "RebindableSyntax"
      , "UndecidableSuperClasses"
      ]

let discouragedExtensions
    : List Text
    = [ "ImplicitParams", "UndecidableInstances" ]

let rules
    : List Types.Rule
    = [ Builder.extensions
          [ Builder.extensionNamesWithin dangerousExtensions ([] : List Text) ]
      , Builder.extensions
          [ Builder.extensionNamesWithin discouragedExtensions ([] : List Text)
          ]
      ]

in  rules
