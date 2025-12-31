let Types = ../Types.dhall

let Builder = ../Builder.dhall

let partialHashMap =
      \(module : Text) ->
        [ Builder.restrictFunction
            "${module}.!"
            "Partial: throws on missing key. Use ${module}.lookup or ${module}.!? instead"
        ]

let rules
    : List Types.Rule
    = [ Builder.functions (partialHashMap "Data.HashMap.Strict")
      , Builder.functions (partialHashMap "Data.HashMap.Lazy")
      ]

in  rules
