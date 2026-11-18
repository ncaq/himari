let Prelude =
      https://prelude.dhall-lang.org/v20.1.0/package.dhall
        sha256:26b0ef498663d269e4dc6a82b0ee289ec565d683ef4c00d0ebdd25333a5a3c98

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
