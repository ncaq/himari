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
              "decodeStrict"
              "Discards error info. Use eitherDecodeStrict instead to get error messages."
          , Builder.restrictInModule
              "Data.Aeson"
              "decodeFileStrict"
              "Discards error info. Use eitherDecodeFileStrict instead to get error messages."
          , Builder.restrictInModule
              "Data.Aeson"
              "decodeStrictText"
              "Discards error info. Use eitherDecodeStrictText instead to get error messages."
          ]
      , Builder.functions
          [ Builder.restrictInModule
              "Data.Aeson"
              "decode'"
              "Deprecated alias since aeson 2.2.0.0. Use eitherDecode instead."
          , Builder.restrictInModule
              "Data.Aeson"
              "decodeStrict'"
              "Deprecated alias since aeson 2.2.0.0. Use eitherDecodeStrict instead."
          , Builder.restrictInModule
              "Data.Aeson"
              "decodeFileStrict'"
              "Deprecated alias since aeson 2.2.0.0. Use eitherDecodeFileStrict instead."
          ]
      , Builder.functions
          [ Builder.restrictInModule
              "Data.Aeson"
              "eitherDecode'"
              "Deprecated alias since aeson 2.2.0.0. Use eitherDecode instead."
          , Builder.restrictInModule
              "Data.Aeson"
              "eitherDecodeStrict'"
              "Deprecated alias since aeson 2.2.0.0. Use eitherDecodeStrict instead."
          , Builder.restrictInModule
              "Data.Aeson"
              "eitherDecodeFileStrict'"
              "Deprecated alias since aeson 2.2.0.0. Use eitherDecodeFileStrict instead."
          ]
      , Builder.functions
          [ Builder.restrictInModule
              "Data.Aeson"
              "throwDecode'"
              "Deprecated alias since aeson 2.2.0.0. Use throwDecode instead."
          , Builder.restrictInModule
              "Data.Aeson"
              "throwDecodeStrict'"
              "Deprecated alias since aeson 2.2.0.0. Use throwDecodeStrict instead."
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
      ]

in  rules
