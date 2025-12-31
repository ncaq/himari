let Types = ../Types.dhall

let Builder = ../Builder.dhall

let unsafeFunctions
    : List Types.Function
    = [ Builder.restrictFunction
          "unsafePrimToPrim"
          "Unsafe primitive state token conversion. Use safe alternatives."
      , Builder.restrictFunction
          "unsafeFreezeArray"
          "Unsafe freeze without copying. Use freezeArray for safety."
      , Builder.restrictFunction
          "unsafeThawArray"
          "Unsafe thaw without copying. Use thawArray for safety."
      , Builder.restrictFunction
          "unsafeFreezeByteArray"
          "Unsafe freeze without copying. Use freezeByteArray for safety."
      , Builder.restrictFunction
          "unsafeThawByteArray"
          "Unsafe thaw without copying. Use thawByteArray for safety."
      , Builder.restrictFunction
          "unsafeFreezeSmallArray"
          "Unsafe freeze without copying. Use freezeSmallArray for safety."
      , Builder.restrictFunction
          "unsafeThawSmallArray"
          "Unsafe thaw without copying. Use thawSmallArray for safety."
      , Builder.restrictFunction
          "unsafeFreezePrimArray"
          "Unsafe freeze without copying. Use freezePrimArray for safety."
      , Builder.restrictFunction
          "unsafeThawPrimArray"
          "Unsafe thaw without copying. Use thawPrimArray for safety."
      ]

let rules
    : List Types.Rule
    = [ Builder.functions unsafeFunctions ]

in  rules
