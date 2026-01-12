-- Rules for language extension restrictions
-- 危険な言語拡張と非推奨の言語拡張に対する警告ルール
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let dangerousExtensionRules
    : List Types.ExtensionItem
    = [ Builder.banExtensionWithMessage
          [ "AllowAmbiguousTypes" ]
          "Defers ambiguity errors to call sites, making debugging harder"
      , Builder.banExtensionWithMessage
          [ "DeferTypeErrors" ]
          "Defers type errors to runtime, defeating Haskell's type safety"
      , Builder.banExtensionWithMessage
          [ "ExtendedDefaultRules" ]
          "Causes unexpected type defaulting (e.g., show.read defaults to ())"
      , Builder.banExtensionWithMessage
          [ "ImpredicativeTypes" ]
          "Experimental and may break in future GHC versions"
      , Builder.banExtensionWithMessage
          [ "IncoherentInstances" ]
          "Makes instance selection non-deterministic and order-dependent"
      , Builder.banExtensionWithMessage
          [ "LiberalTypeSynonyms" ]
          "Can cause Core Lint errors with DataKinds and PolyKinds"
      , Builder.banExtensionWithMessage
          [ "OverlappingInstances" ]
          "Deprecated since GHC 7.10, use OVERLAPPING pragma if truly needed"
      , Builder.banExtensionWithMessage
          [ "RebindableSyntax" ]
          "Changes do/if-then-else semantics, breaks deriving and TH"
      , Builder.banExtensionWithMessage
          [ "UndecidableSuperClasses" ]
          "Can cause type checker non-termination or stack overflow"
      ]

let discouragedExtensionRules
    : List Types.ExtensionItem
    = [ Builder.banExtensionWithMessage
          [ "ImplicitParams" ]
          "Breaks coherence. If unavoidable, add {-# HLINT ignore \"Avoid restricted extensions\" #-}"
      , Builder.banExtensionWithMessage
          [ "UndecidableInstances" ]
          "May cause type checker loops. If unavoidable, add {-# HLINT ignore \"Avoid restricted extensions\" #-}"
      ]

let rules
    : List Types.Rule
    = [ Builder.extensions dangerousExtensionRules
      , Builder.extensions discouragedExtensionRules
      ]

in  rules
