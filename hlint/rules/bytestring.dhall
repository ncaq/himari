-- Data.ByteString部分関数警告
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let partialByteString =
      \(module : Text) ->
        [ Builder.restrictInModule module "head" "Use ${module}.uncons instead"
        , Builder.restrictInModule module "tail" "Use ${module}.uncons instead"
        , Builder.restrictInModule module "init" "Use ${module}.unsnoc instead"
        , Builder.restrictInModule module "last" "Use ${module}.unsnoc instead"
        , Builder.restrictInModule
            module
            "maximum"
            "Partial: throws on empty ByteString. Use fold with explicit initial value."
        , Builder.restrictInModule
            module
            "minimum"
            "Partial: throws on empty ByteString. Use fold with explicit initial value."
        ]

let rules
    : List Types.Rule
    = [ Builder.functions (partialByteString "Data.ByteString")
      , Builder.functions (partialByteString "Data.ByteString.Char8")
      , Builder.functions (partialByteString "Data.ByteString.Lazy")
      , Builder.functions (partialByteString "Data.ByteString.Lazy.Char8")
      , Builder.functions
          (   partialByteString "Data.ByteString.Short"
            # [ Builder.restrictFunction
                  "Data.ByteString.Short.index"
                  "Throws on out-of-bounds. Use Data.ByteString.Short.indexMaybe instead"
              ]
          )
      ]

in  rules
