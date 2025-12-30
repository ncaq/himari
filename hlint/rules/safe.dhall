-- safe package
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    : List Types.Rule
    = [ Builder.functions
          [ Builder.restrictInModule
              "Safe"
              "abort"
              "Partial: synonym for error. Use throwM or Left instead."
          , Builder.restrictInModule
              "Safe"
              "at"
              "Partial: throws on out-of-bounds. Use atMay or atDef instead."
          , Builder.restrictInModule
              "Safe"
              "headErr"
              "Partial: throws on empty list. Use headMay or headDef instead."
          , Builder.restrictInModule
              "Safe"
              "tailErr"
              "Partial: throws on empty list. Use tailMay or tailDef instead."
          , Builder.restrictInModule
              "Safe"
              "lookupJust"
              "Partial: throws on missing key. Use lookup or lookupJustDef instead."
          , Builder.restrictInModule
              "Safe"
              "findJust"
              "Partial: throws when not found. Use find or findJustDef instead."
          , Builder.restrictInModule
              "Safe"
              "elemIndexJust"
              "Partial: throws when not found. Use elemIndex or elemIndexJustDef instead."
          , Builder.restrictInModule
              "Safe"
              "findIndexJust"
              "Partial: throws when not found. Use findIndex or findIndexJustDef instead."
          ]
      , Builder.functions
          [ Builder.restrictInModule
              "Safe"
              "tailNote"
              "Partial: throws on empty list. Use tailMay or tailDef instead."
          , Builder.restrictInModule
              "Safe"
              "initNote"
              "Partial: throws on empty list. Use initMay or initDef instead."
          , Builder.restrictInModule
              "Safe"
              "headNote"
              "Partial: throws on empty list. Use headMay or headDef instead."
          , Builder.restrictInModule
              "Safe"
              "lastNote"
              "Partial: throws on empty list. Use lastMay or lastDef instead."
          , Builder.restrictInModule
              "Safe"
              "minimumNote"
              "Partial: throws on empty list. Use minimumMay or minimumBound instead."
          , Builder.restrictInModule
              "Safe"
              "maximumNote"
              "Partial: throws on empty list. Use maximumMay or maximumBound instead."
          , Builder.restrictInModule
              "Safe"
              "minimumByNote"
              "Partial: throws on empty list. Use minimumByMay or minimumBoundBy instead."
          , Builder.restrictInModule
              "Safe"
              "maximumByNote"
              "Partial: throws on empty list. Use maximumByMay or maximumBoundBy instead."
          , Builder.restrictInModule
              "Safe"
              "foldr1Note"
              "Partial: throws on empty list. Use foldr1May instead."
          , Builder.restrictInModule
              "Safe"
              "foldl1Note"
              "Partial: throws on empty list. Use foldl1May instead."
          , Builder.restrictInModule
              "Safe"
              "foldl1Note'"
              "Partial: throws on empty list. Use foldl1May' instead."
          , Builder.restrictInModule
              "Safe"
              "scanr1Note"
              "Partial: throws on empty list. Use scanr1May or scanr1Def instead."
          , Builder.restrictInModule
              "Safe"
              "scanl1Note"
              "Partial: throws on empty list. Use scanl1May or scanl1Def instead."
          , Builder.restrictInModule
              "Safe"
              "cycleNote"
              "Partial: throws on empty list. Use cycleMay or cycleDef instead."
          , Builder.restrictInModule
              "Safe"
              "fromJustNote"
              "Partial: throws on Nothing. Use fromMaybe instead."
          , Builder.restrictInModule
              "Safe"
              "assertNote"
              "Partial: throws on False. Use guard or when instead."
          , Builder.restrictInModule
              "Safe"
              "atNote"
              "Partial: throws on out-of-bounds. Use atMay or atDef instead."
          , Builder.restrictInModule
              "Safe"
              "readNote"
              "Partial: throws on parse failure. Use readMay or readDef instead."
          , Builder.restrictInModule
              "Safe"
              "lookupJustNote"
              "Partial: throws on missing key. Use lookup or lookupJustDef instead."
          , Builder.restrictInModule
              "Safe"
              "findJustNote"
              "Partial: throws when not found. Use find or findJustDef instead."
          , Builder.restrictInModule
              "Safe"
              "elemIndexJustNote"
              "Partial: throws when not found. Use elemIndex or elemIndexJustDef instead."
          , Builder.restrictInModule
              "Safe"
              "findIndexJustNote"
              "Partial: throws when not found. Use findIndex or findIndexJustDef instead."
          , Builder.restrictInModule
              "Safe"
              "toEnumNote"
              "Partial: throws on out-of-bounds. Use toEnumMay or toEnumDef instead."
          , Builder.restrictInModule
              "Safe"
              "succNote"
              "Partial: throws on maxBound. Use succMay or succDef instead."
          , Builder.restrictInModule
              "Safe"
              "predNote"
              "Partial: throws on minBound. Use predMay or predDef instead."
          , Builder.restrictInModule
              "Safe"
              "indexNote"
              "Partial: throws on out-of-range. Use indexMay or indexDef instead."
          ]
      , Builder.functions
          [ Builder.restrictInModule
              "Safe.Exact"
              "takeExact"
              "Partial: throws on insufficient elements. Use takeExactMay or takeExactDef instead."
          , Builder.restrictInModule
              "Safe.Exact"
              "dropExact"
              "Partial: throws on insufficient elements. Use dropExactMay or dropExactDef instead."
          , Builder.restrictInModule
              "Safe.Exact"
              "splitAtExact"
              "Partial: throws on insufficient elements. Use splitAtExactMay or splitAtExactDef instead."
          , Builder.restrictInModule
              "Safe.Exact"
              "zipExact"
              "Partial: throws on length mismatch. Use zipExactMay or zipExactDef instead."
          , Builder.restrictInModule
              "Safe.Exact"
              "zipWithExact"
              "Partial: throws on length mismatch. Use zipWithExactMay or zipWithExactDef instead."
          , Builder.restrictInModule
              "Safe.Exact"
              "zip3Exact"
              "Partial: throws on length mismatch. Use zip3ExactMay or zip3ExactDef instead."
          , Builder.restrictInModule
              "Safe.Exact"
              "zipWith3Exact"
              "Partial: throws on length mismatch. Use zipWith3ExactMay or zipWith3ExactDef instead."
          , Builder.restrictInModule
              "Safe.Exact"
              "takeExactNote"
              "Partial: throws on insufficient elements. Use takeExactMay or takeExactDef instead."
          , Builder.restrictInModule
              "Safe.Exact"
              "dropExactNote"
              "Partial: throws on insufficient elements. Use dropExactMay or dropExactDef instead."
          , Builder.restrictInModule
              "Safe.Exact"
              "splitAtExactNote"
              "Partial: throws on insufficient elements. Use splitAtExactMay or splitAtExactDef instead."
          , Builder.restrictInModule
              "Safe.Exact"
              "zipExactNote"
              "Partial: throws on length mismatch. Use zipExactMay or zipExactDef instead."
          , Builder.restrictInModule
              "Safe.Exact"
              "zipWithExactNote"
              "Partial: throws on length mismatch. Use zipWithExactMay or zipWithExactDef instead."
          , Builder.restrictInModule
              "Safe.Exact"
              "zip3ExactNote"
              "Partial: throws on length mismatch. Use zip3ExactMay or zip3ExactDef instead."
          , Builder.restrictInModule
              "Safe.Exact"
              "zipWith3ExactNote"
              "Partial: throws on length mismatch. Use zipWith3ExactMay or zipWith3ExactDef instead."
          ]
      , Builder.functions
          [ Builder.restrictInModule
              "Safe.Foldable"
              "foldl1Note"
              "Partial: throws on empty structure. Use foldl1May instead."
          , Builder.restrictInModule
              "Safe.Foldable"
              "foldr1Note"
              "Partial: throws on empty structure. Use foldr1May instead."
          , Builder.restrictInModule
              "Safe.Foldable"
              "minimumNote"
              "Partial: throws on empty structure. Use minimumMay or minimumBound instead."
          , Builder.restrictInModule
              "Safe.Foldable"
              "maximumNote"
              "Partial: throws on empty structure. Use maximumMay or maximumBound instead."
          , Builder.restrictInModule
              "Safe.Foldable"
              "minimumByNote"
              "Partial: throws on empty structure. Use minimumByMay or minimumBoundBy instead."
          , Builder.restrictInModule
              "Safe.Foldable"
              "maximumByNote"
              "Partial: throws on empty structure. Use maximumByMay or maximumBoundBy instead."
          , Builder.restrictInModule
              "Safe.Foldable"
              "findJust"
              "Partial: throws when not found. Use find or findJustDef instead."
          , Builder.restrictInModule
              "Safe.Foldable"
              "findJustNote"
              "Partial: throws when not found. Use find or findJustDef instead."
          ]
      ]

in  rules
