-- aeson部分関数・危険な関数警告
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    : List Types.Rule
    = [ Builder.functions
          [ Builder.restrictInModule
              "Data.Aeson"
              "decode"
              "Discards error info. Use eitherDecode instead to get error messages."
          , Builder.restrictInModule
              "Data.Aeson"
              "decode'"
              "Discards error info. Use eitherDecode' instead to get error messages."
          , Builder.restrictInModule
              "Data.Aeson"
              "decodeStrict"
              "Discards error info. Use eitherDecodeStrict instead to get error messages."
          , Builder.restrictInModule
              "Data.Aeson"
              "decodeStrict'"
              "Discards error info. Use eitherDecodeStrict' instead to get error messages."
          , Builder.restrictInModule
              "Data.Aeson"
              "decodeFileStrict"
              "Discards error info. Use eitherDecodeFileStrict instead to get error messages."
          , Builder.restrictInModule
              "Data.Aeson"
              "decodeFileStrict'"
              "Discards error info. Use eitherDecodeFileStrict' instead to get error messages."
          , Builder.restrictInModule
              "Data.Aeson"
              "decodeStrictText"
              "Discards error info. Use eitherDecodeStrictText instead to get error messages."
          ]
      , Builder.functions
          [ Builder.restrictInModule
              "Data.Aeson"
              "parseMaybe"
              "Discards error info. Use parseEither instead to get error messages."
          , Builder.restrictInModule
              "Data.Aeson.Types"
              "parseMaybe"
              "Discards error info. Use parseEither instead to get error messages."
          , Builder.restrictInModule
              "Data.Aeson.Types.Internal"
              "parseMaybe"
              "Discards error info. Use parseEither instead to get error messages."
          ]
      , Builder.functions
          [ Builder.restrictInModule
              "Data.Aeson"
              "fromJSON"
              "Result type lacks JSONPath info. Use parseEither parseJSON instead for detailed errors."
          , Builder.restrictInModule
              "Data.Aeson.Types"
              "fromJSON"
              "Result type lacks JSONPath info. Use parseEither parseJSON instead for detailed errors."
          , Builder.restrictInModule
              "Data.Aeson.Types.Class"
              "fromJSON"
              "Result type lacks JSONPath info. Use parseEither parseJSON instead for detailed errors."
          ]
      ]

in  rules
