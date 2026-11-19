let Prelude = ../Prelude.dhall

let Types = ../Types.dhall

let Builder = ../Builder.dhall

let safeConvertFunctions =
      [ "Data.Text.Encoding.decodeUtf8", "Data.Text.Lazy.Encoding.decodeUtf8" ]

let rules
    : List Types.Rule
    = Prelude.List.map
        Text
        Types.Rule
        Builder.useSafeConvert
        safeConvertFunctions

in  rules
