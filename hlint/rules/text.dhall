-- Data.Text部分関数警告
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let partialText =
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
        ]

let rules
    : List Types.Rule
    = [ Builder.functions (partialText "Data.Text")
      , Builder.functions (partialText "Data.Text.Lazy")
      ]

in  rules
