-- Map/HashMap/Set/IntMap/IntSet/Sequence部分関数警告
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let partialMap =
      \(module : Text) ->
        [ Builder.restrictFunction
            "${module}.!"
            "Use ${module}.lookup or ${module}.!? instead"
        , Builder.restrictInModule
            module
            "findMin"
            "Partial: throws on empty map. Use ${module}.lookupMin instead."
        , Builder.restrictInModule
            module
            "findMax"
            "Partial: throws on empty map. Use ${module}.lookupMax instead."
        , Builder.restrictInModule
            module
            "elemAt"
            "Partial: throws on out-of-bounds. Use ${module}.lookupMin/lookupMax or check size."
        , Builder.restrictInModule
            module
            "deleteAt"
            "Partial: throws on out-of-bounds. Check size before using."
        , Builder.restrictInModule
            module
            "findIndex"
            "Partial: throws if key not found. Use ${module}.lookupIndex instead."
        , Builder.restrictInModule
            module
            "updateAt"
            "Partial: throws on out-of-bounds. Check size before using."
        , Builder.restrictInModule
            module
            "deleteFindMin"
            "Partial: throws on empty map. Use ${module}.minViewWithKey instead."
        , Builder.restrictInModule
            module
            "deleteFindMax"
            "Partial: throws on empty map. Use ${module}.maxViewWithKey instead."
        ]

let partialSet =
      \(module : Text) ->
        [ Builder.restrictInModule
            module
            "findMin"
            "Partial: throws on empty set. Use ${module}.lookupMin instead."
        , Builder.restrictInModule
            module
            "findMax"
            "Partial: throws on empty set. Use ${module}.lookupMax instead."
        , Builder.restrictInModule
            module
            "elemAt"
            "Partial: throws on out-of-bounds. Use ${module}.lookupMin/lookupMax or check size."
        , Builder.restrictInModule
            module
            "deleteAt"
            "Partial: throws on out-of-bounds. Check size before using."
        , Builder.restrictInModule
            module
            "findIndex"
            "Partial: throws if element not found. Use ${module}.lookupIndex instead."
        , Builder.restrictInModule
            module
            "deleteFindMin"
            "Partial: throws on empty set. Use ${module}.minView instead."
        , Builder.restrictInModule
            module
            "deleteFindMax"
            "Partial: throws on empty set. Use ${module}.maxView instead."
        ]

let partialIntMap =
      \(module : Text) ->
        [ Builder.restrictFunction
            "${module}.!"
            "Use ${module}.lookup or ${module}.!? instead"
        , Builder.restrictInModule
            module
            "findMin"
            "Partial: throws on empty map. Use ${module}.lookupMin instead."
        , Builder.restrictInModule
            module
            "findMax"
            "Partial: throws on empty map. Use ${module}.lookupMax instead."
        , Builder.restrictInModule
            module
            "deleteFindMin"
            "Partial: throws on empty map. Use ${module}.minViewWithKey instead."
        , Builder.restrictInModule
            module
            "deleteFindMax"
            "Partial: throws on empty map. Use ${module}.maxViewWithKey instead."
        ]

let partialIntSet =
      let module = "Data.IntSet"

      in  [ Builder.restrictInModule
              module
              "findMin"
              "Partial: throws on empty set. Use ${module}.lookupMin instead."
          , Builder.restrictInModule
              module
              "findMax"
              "Partial: throws on empty set. Use ${module}.lookupMax instead."
          , Builder.restrictInModule
              module
              "deleteFindMin"
              "Partial: throws on empty set. Use ${module}.minView instead."
          , Builder.restrictInModule
              module
              "deleteFindMax"
              "Partial: throws on empty set. Use ${module}.maxView instead."
          ]

let partialSequence =
      let module = "Data.Sequence"

      in  [ Builder.restrictInModule
              module
              "index"
              "Partial: throws on out-of-bounds. Use ${module}.lookup or ${module}.!? instead."
          , Builder.restrictInModule
              module
              "scanl1"
              "Partial: throws on empty Seq."
          , Builder.restrictInModule
              module
              "scanr1"
              "Partial: throws on empty Seq."
          ]

let rules
    : List Types.Rule
    = [ Builder.functions (partialMap "Data.Map")
      , Builder.functions (partialMap "Data.Map.Strict")
      , Builder.functions (partialMap "Data.Map.Lazy")
      , Builder.functions (partialSet "Data.Set")
      , Builder.functions (partialIntMap "Data.IntMap")
      , Builder.functions (partialIntMap "Data.IntMap.Strict")
      , Builder.functions (partialIntMap "Data.IntMap.Lazy")
      , Builder.functions partialIntSet
      , Builder.functions partialSequence
      , Builder.functions
          [ Builder.restrictFunction
              "Data.HashMap.Strict.!"
              "Use Data.HashMap.lookup instead"
          , Builder.restrictFunction
              "Data.HashMap.Lazy.!"
              "Use Data.HashMap.lookup instead"
          ]
      ]

in  rules
