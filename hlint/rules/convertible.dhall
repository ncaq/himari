let Prelude =
      https://prelude.dhall-lang.org/v23.1.0/package.dhall
        sha256:931cbfae9d746c4611b07633ab1e547637ab4ba138b16bf65ef1b9ad66a60b7f

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
