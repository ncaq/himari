-- Rules for language extension restrictions
-- 危険な言語拡張と非推奨の言語拡張に対する警告ルール
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let allowAmbiguousTypesMessage =
      "Defers ambiguity errors to call sites, making debugging harder"

let allowAmbiguousTypes =
      Builder.banExtensionWithMessage
        [ "AllowAmbiguousTypes" ]
        allowAmbiguousTypesMessage

let deferTypeErrorsMessage =
      "Defers type errors to runtime, defeating Haskell's type safety"

let deferTypeErrors =
      Builder.banExtensionWithMessage
        [ "DeferTypeErrors" ]
        deferTypeErrorsMessage

let extendedDefaultRulesMessage =
      "Causes unexpected type defaulting (e.g., show.read defaults to ())"

let extendedDefaultRules =
      Builder.banExtensionWithMessage
        [ "ExtendedDefaultRules" ]
        extendedDefaultRulesMessage

let impredicativeTypesMessage =
      "Experimental and may break in future GHC versions"

let impredicativeTypes =
      Builder.banExtensionWithMessage
        [ "ImpredicativeTypes" ]
        impredicativeTypesMessage

let incoherentInstancesMessage =
      "Makes instance selection non-deterministic and order-dependent"

let incoherentInstances =
      Builder.banExtensionWithMessage
        [ "IncoherentInstances" ]
        incoherentInstancesMessage

let liberalTypeSynonymsMessage =
      "Can cause Core Lint errors with DataKinds and PolyKinds"

let liberalTypeSynonyms =
      Builder.banExtensionWithMessage
        [ "LiberalTypeSynonyms" ]
        liberalTypeSynonymsMessage

let overlappingInstancesMessage =
      "Deprecated since GHC 7.10, use OVERLAPPING pragma if truly needed"

let overlappingInstances =
      Builder.banExtensionWithMessage
        [ "OverlappingInstances" ]
        overlappingInstancesMessage

let rebindableSyntaxMessage =
      "Changes do/if-then-else semantics, breaks deriving and TH"

let rebindableSyntax =
      Builder.banExtensionWithMessage
        [ "RebindableSyntax" ]
        rebindableSyntaxMessage

let undecidableSuperClassesMessage =
      "Can cause type checker non-termination or stack overflow"

let undecidableSuperClasses =
      Builder.banExtensionWithMessage
        [ "UndecidableSuperClasses" ]
        undecidableSuperClassesMessage

let dangerousExtensions
    : List Types.ExtensionItem
    = [ allowAmbiguousTypes
      , deferTypeErrors
      , extendedDefaultRules
      , impredicativeTypes
      , incoherentInstances
      , liberalTypeSynonyms
      , overlappingInstances
      , rebindableSyntax
      , undecidableSuperClasses
      ]

let implicitParamsMessage =
          "Breaks coherence. "
      ++  "If unavoidable, add {-# HLINT ignore \"Avoid restricted extensions\" #-}"

let implicitParams =
      Builder.banExtensionWithMessage [ "ImplicitParams" ] implicitParamsMessage

let undecidableInstancesMessage =
          "May cause type checker loops. "
      ++  "If unavoidable, add {-# HLINT ignore \"Avoid restricted extensions\" #-}"

let undecidableInstances =
      Builder.banExtensionWithMessage
        [ "UndecidableInstances" ]
        undecidableInstancesMessage

let discouragedExtensions
    : List Types.ExtensionItem
    = [ implicitParams, undecidableInstances ]

let rules
    : List Types.Rule
    = [ Builder.extensions dangerousExtensions
      , Builder.extensions discouragedExtensions
      ]

in  rules
