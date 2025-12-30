-- 基本的な部分関数警告
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    : List Types.Rule
    = [ Builder.functions
          [ Builder.restrictInModule
              "Data.List"
              "head"
              "Partial: throws on empty list. Use listToMaybe or pattern match."
          , Builder.restrictInModule
              "Data.List"
              "tail"
              "Partial: throws on empty list. Use drop 1 or pattern match."
          , Builder.restrictInModule
              "Data.List"
              "init"
              "Partial: throws on empty list. Use initMay from safe package."
          , Builder.restrictInModule
              "Data.List"
              "last"
              "Partial: throws on empty list. Use lastMay from safe package."
          , Builder.restrictFunction
              "Data.List.!!"
              "Partial: throws on out-of-bounds. Use safe indexing."
          , Builder.restrictInModule
              "Data.Maybe"
              "fromJust"
              "Partial: throws on Nothing. Use fromMaybe or pattern match."
          , Builder.restrictInModule
              "Data.List.NonEmpty"
              "fromList"
              "Partial: throws on empty list. Use nonEmpty instead."
          ]
      , Builder.functions
          [ Builder.restrictInModule
              "Data.Foldable"
              "foldl1"
              "Use foldl' with a default value instead"
          , Builder.restrictInModule
              "Data.Foldable"
              "foldr1"
              "Use foldr with a default value instead"
          , Builder.restrictInModule
              "Data.Foldable"
              "maximum"
              "Use maximumMay from safe package or viaNonEmpty maximum"
          , Builder.restrictInModule
              "Data.Foldable"
              "minimum"
              "Use minimumMay from safe package or viaNonEmpty minimum"
          , Builder.restrictInModule
              "Data.Foldable"
              "maximumBy"
              "Use maximumByMay from safe package"
          , Builder.restrictInModule
              "Data.Foldable"
              "minimumBy"
              "Use minimumByMay from safe package"
          ]
      , Builder.functions
          [ Builder.restrictInModule
              "Data.Bifoldable"
              "bifoldl1"
              "Use bifoldl with a default value instead"
          , Builder.restrictInModule
              "Data.Bifoldable"
              "bifoldr1"
              "Use bifoldr with a default value instead"
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
      , Builder.functions
          [ Builder.restrictFunction
              "read"
              "Use readMaybe or readEither instead. read also operates on String."
          ]
      , Builder.functions
          [ Builder.restrictFunction
              "toEnum"
              "Partial: throws on out-of-bounds. Use explicit bounds checking."
          , Builder.restrictFunction
              "pred"
              "Partial: throws on minBound. Use explicit bounds checking."
          , Builder.restrictFunction
              "succ"
              "Partial: throws on maxBound. Use explicit bounds checking."
          ]
      , Builder.functions
          [ Builder.restrictInModule
              "Data.Char"
              "digitToInt"
              "Partial: throws on non-hex-digit character. No safe alternative exists. Use pattern matching on '0'..'9', 'a'..'f', 'A'..'F'."
          , Builder.restrictInModule
              "Data.Char"
              "intToDigit"
              "Partial: throws on out-of-range (must be 0-15). Use explicit bounds checking."
          , Builder.restrictInModule
              "Data.Char"
              "chr"
              "Partial: throws on invalid code point. Use explicit bounds checking."
          ]
      , Builder.functions
          [ Builder.restrictInModule
              "Data.List"
              "foldl1'"
              "Partial: throws on empty list. Use foldl' with explicit initial value."
          ]
      , Builder.functions
          [ Builder.restrictFunction
              "Data.List.NonEmpty.!!"
              "Partial: throws on out-of-bounds. Use safe indexing."
          ]
      ]

in  rules
