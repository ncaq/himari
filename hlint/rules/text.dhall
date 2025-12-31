-- Data.Text部分関数警告
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let partialTextCommon =
      \(module : Text) ->
        [ Builder.restrictInModule module "head" "Use ${module}.uncons instead"
        , Builder.restrictInModule module "tail" "Use ${module}.uncons instead"
        , Builder.restrictInModule module "init" "Use ${module}.unsnoc instead"
        , Builder.restrictInModule module "last" "Use ${module}.unsnoc instead"
        , Builder.restrictInModule
            module
            "foldl1"
            "Partial: throws on empty Text. Use foldl with explicit initial value."
        , Builder.restrictInModule
            module
            "foldl1'"
            "Partial: throws on empty Text. Use foldl' with explicit initial value."
        , Builder.restrictInModule
            module
            "foldr1"
            "Partial: throws on empty Text. Use foldr with explicit initial value."
        , Builder.restrictInModule
            module
            "maximum"
            "Partial: throws on empty Text. Use fold with explicit initial value."
        , Builder.restrictInModule
            module
            "minimum"
            "Partial: throws on empty Text. Use fold with explicit initial value."
        , Builder.restrictInModule
            module
            "index"
            "Partial: throws on out-of-bounds. Use safe indexing alternatives."
        ]

let partialTextLazy =
      \(module : Text) ->
          partialTextCommon module
        # [ Builder.restrictInModule
              module
              "cycle"
              "Partial: throws on empty Text."
          ]

let unsafeTextFunctions =
      let module = "Data.Text.Unsafe"

      in  [ Builder.restrictInModule
              module
              "unsafeHead"
              "Unsafe: no bounds check. Use Data.Text.uncons instead"
          , Builder.restrictInModule
              module
              "unsafeTail"
              "Unsafe: no bounds check. Use Data.Text.uncons instead"
          , Builder.restrictInModule
              module
              "takeWord8"
              "Unsafe: no bounds check. Use Data.Text.take instead"
          , Builder.restrictInModule
              module
              "dropWord8"
              "Unsafe: no bounds check. Use Data.Text.drop instead"
          ]

let rules
    : List Types.Rule
    = [ Builder.functions (partialTextCommon "Data.Text")
      , Builder.functions (partialTextLazy "Data.Text.Lazy")
      , Builder.functions unsafeTextFunctions
      ]

in  rules
