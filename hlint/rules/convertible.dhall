let Prelude =
      https://prelude.dhall-lang.org/v23.1.0/package.dhall
        sha256:931cbfae9d746c4611b07633ab1e547637ab4ba138b16bf65ef1b9ad66a60b7f

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
    = Prelude.List.map Text Types.Rule Builder.useConvert convertFunctions

in  rules
