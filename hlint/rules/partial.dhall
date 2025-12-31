-- 基本的な部分関数警告 (safeパッケージで代替できないもの)
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    : List Types.Rule
    = [ Builder.functions
          [ Builder.restrictInModule
              "Data.Bifoldable"
              "bifoldl1"
              "Partial: throws on empty structure. Use bifoldl with a default value instead."
          , Builder.restrictInModule
              "Data.Bifoldable"
              "bifoldr1"
              "Partial: throws on empty structure. Use bifoldr with a default value instead."
          , Builder.restrictInModule
              "Data.Bifoldable"
              "bimaximum"
              "Partial: throws on empty structure. Use bifoldr with explicit initial value."
          , Builder.restrictInModule
              "Data.Bifoldable"
              "biminimum"
              "Partial: throws on empty structure. Use bifoldr with explicit initial value."
          , Builder.restrictInModule
              "Data.Bifoldable"
              "bimaximumBy"
              "Partial: throws on empty structure. Use bifoldr with explicit initial value."
          , Builder.restrictInModule
              "Data.Bifoldable"
              "biminimumBy"
              "Partial: throws on empty structure. Use bifoldr with explicit initial value."
          ]
      ]

in  rules
