-- Map/HashMap部分関数警告
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    : List Types.Rule
    = [ Builder.functions
          [ Builder.restrictFunction
              "Data.Map.!"
              "Use Data.Map.lookup or Data.Map.!? instead"
          , Builder.restrictInModule
              "Data.Map"
              "findMin"
              "Use Data.Map.lookupMin instead"
          , Builder.restrictInModule
              "Data.Map"
              "findMax"
              "Use Data.Map.lookupMax instead"
          , Builder.restrictFunction
              "Data.HashMap.Strict.!"
              "Use Data.HashMap.lookup instead"
          , Builder.restrictFunction
              "Data.HashMap.Lazy.!"
              "Use Data.HashMap.lookup instead"
          ]
      ]

in  rules
