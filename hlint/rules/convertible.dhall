-- convertible推奨ルール
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let convertFunctions =
      [ "Data.Text.pack"
      , "Data.Text.unpack"
      , "Data.Text.Lazy.pack"
      , "Data.Text.Lazy.unpack"
      , "Data.Text.Lazy.toStrict"
      , "Data.Text.Lazy.fromStrict"
      , "Data.Text.Encoding.encodeUtf8"
      , "Data.Text.Encoding.decodeUtf8"
      , "Data.Text.Lazy.Encoding.encodeUtf8"
      , "Data.Text.Lazy.Encoding.decodeUtf8"
      , "Data.ByteString.pack"
      , "Data.ByteString.unpack"
      , "Data.ByteString.Lazy.pack"
      , "Data.ByteString.Lazy.unpack"
      , "Data.ByteString.Lazy.toStrict"
      , "Data.ByteString.Lazy.fromStrict"
      , "Data.Text.Lazy.Builder.fromText"
      , "Data.Text.Lazy.Builder.fromLazyText"
      , "Data.Text.Lazy.Builder.fromString"
      , "Data.Text.Lazy.Builder.toLazyText"
      ]

let rules
    : List Types.Rule
    = Builder.Prelude.List.map
        Text
        Types.Rule
        Builder.useConvert
        convertFunctions

in  rules
