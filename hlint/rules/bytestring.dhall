let Types = ../Types.dhall

let Builder = ../Builder.dhall

let partialByteStringCommon =
      \(module : Text) ->
        [ Builder.restrictInModule module "head" "Use ${module}.uncons instead"
        , Builder.restrictInModule module "tail" "Use ${module}.uncons instead"
        , Builder.restrictInModule module "init" "Use ${module}.unsnoc instead"
        , Builder.restrictInModule module "last" "Use ${module}.unsnoc instead"
        , Builder.restrictInModule
            module
            "foldl1"
            "Partial: throws on empty ByteString. Use foldl with explicit initial value."
        , Builder.restrictInModule
            module
            "foldl1'"
            "Partial: throws on empty ByteString. Use foldl' with explicit initial value."
        , Builder.restrictInModule
            module
            "foldr1"
            "Partial: throws on empty ByteString. Use foldr with explicit initial value."
        , Builder.restrictInModule
            module
            "foldr1'"
            "Partial: throws on empty ByteString. Use foldr' with explicit initial value."
        , Builder.restrictInModule
            module
            "maximum"
            "Partial: throws on empty ByteString. Use fold with explicit initial value."
        , Builder.restrictInModule
            module
            "minimum"
            "Partial: throws on empty ByteString. Use fold with explicit initial value."
        , Builder.restrictInModule
            module
            "index"
            "Partial: throws on out-of-bounds. Use ${module}.indexMaybe or ${module}.(!?) instead"
        ]

let partialByteStringLazy =
      \(module : Text) ->
          partialByteStringCommon module
        # [ Builder.restrictInModule
              module
              "cycle"
              "Partial: throws on empty ByteString."
          ]

let partialShortByteString =
      let module = "Data.ByteString.Short"

      in  [ Builder.restrictInModule
              module
              "head"
              "Use ${module}.uncons instead"
          , Builder.restrictInModule
              module
              "tail"
              "Use ${module}.uncons instead"
          , Builder.restrictInModule
              module
              "init"
              "Use ${module}.unsnoc instead"
          , Builder.restrictInModule
              module
              "last"
              "Use ${module}.unsnoc instead"
          , Builder.restrictInModule
              module
              "foldl1"
              "Partial: throws on empty ShortByteString. Use foldl with explicit initial value."
          , Builder.restrictInModule
              module
              "foldl1'"
              "Partial: throws on empty ShortByteString. Use foldl' with explicit initial value."
          , Builder.restrictInModule
              module
              "foldr1"
              "Partial: throws on empty ShortByteString. Use foldr with explicit initial value."
          , Builder.restrictInModule
              module
              "foldr1'"
              "Partial: throws on empty ShortByteString. Use foldr' with explicit initial value."
          , Builder.restrictInModule
              module
              "index"
              "Partial: throws on out-of-bounds. Use ${module}.indexMaybe or ${module}.(!?) instead"
          ]

let unsafeByteStringFunctions =
      let module = "Data.ByteString.Unsafe"

      in  [ Builder.restrictInModule
              module
              "unsafeHead"
              "Unsafe: no bounds check. Use Data.ByteString.uncons instead"
          , Builder.restrictInModule
              module
              "unsafeTail"
              "Unsafe: no bounds check. Use Data.ByteString.uncons instead"
          , Builder.restrictInModule
              module
              "unsafeInit"
              "Unsafe: no bounds check. Use Data.ByteString.unsnoc instead"
          , Builder.restrictInModule
              module
              "unsafeLast"
              "Unsafe: no bounds check. Use Data.ByteString.unsnoc instead"
          , Builder.restrictInModule
              module
              "unsafeIndex"
              "Unsafe: no bounds check. Use Data.ByteString.indexMaybe instead"
          , Builder.restrictInModule
              module
              "unsafeTake"
              "Unsafe: no bounds check. Use Data.ByteString.take instead"
          , Builder.restrictInModule
              module
              "unsafeDrop"
              "Unsafe: no bounds check. Use Data.ByteString.drop instead"
          ]

let rules
    : List Types.Rule
    = [ Builder.functions (partialByteStringCommon "Data.ByteString")
      , Builder.functions (partialByteStringCommon "Data.ByteString.Char8")
      , Builder.functions (partialByteStringLazy "Data.ByteString.Lazy")
      , Builder.functions (partialByteStringLazy "Data.ByteString.Lazy.Char8")
      , Builder.functions partialShortByteString
      , Builder.functions unsafeByteStringFunctions
      ]

in  rules
