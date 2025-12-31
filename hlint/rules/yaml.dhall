let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    : List Types.Rule
    = [ Builder.functions
          [ Builder.restrictInModule
              "Data.Yaml"
              "decode"
              "Discards error info. Use decodeEither' or decodeThrow instead."
          , Builder.restrictInModule
              "Data.Yaml"
              "decodeFile"
              "Discards error info. Use decodeFileEither or decodeFileThrow instead."
          ]
      , Builder.functions
          [ Builder.restrictInModule
              "Data.Yaml"
              "decodeEither"
              "Deprecated. Use decodeEither' instead for ParseException details."
          ]
      ]

in  rules
