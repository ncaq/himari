-- qualified importのエイリアス名ガイドライン
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    : List Types.Rule
    = [ Builder.modules
          [ Builder.qualifiedAs "Data.ByteString" "B"
          , Builder.qualifiedAs "Data.ByteString.Char8" "B8"
          , Builder.qualifiedAs "Data.ByteString.Lazy" "BL"
          , Builder.qualifiedAs "Data.ByteString.Lazy.Char8" "BL8"
          , Builder.qualifiedAs "Data.Text" "T"
          , Builder.qualifiedAs "Data.Text.Lazy" "TL"
          , Builder.banModule
              "Data.Map"
              "Data.Map is a re-export of Data.Map.Lazy. Use Data.Map.Strict or Data.Map.Lazy directly."
          , Builder.qualifiedAs "Data.Map.Strict" "Map"
          , Builder.qualifiedAs "Data.Map.Lazy" "MapL"
          , Builder.banModule
              "Data.IntMap"
              "Data.IntMap is a re-export of Data.IntMap.Lazy. Use Data.IntMap.Strict or Data.IntMap.Lazy directly."
          , Builder.qualifiedAs "Data.IntMap.Strict" "IntMap"
          , Builder.qualifiedAs "Data.IntMap.Lazy" "IntMapL"
          , Builder.qualifiedAs "Data.Set" "Set"
          , Builder.qualifiedAs "Data.Sequence" "Seq"
          , Builder.qualifiedAs "Data.IntSet" "IntSet"
          , Builder.qualifiedAs "Data.HashMap.Strict" "HM"
          , Builder.qualifiedAs "Data.HashMap.Lazy" "HML"
          , Builder.qualifiedAs "Data.HashSet" "HS"
          , Builder.qualifiedAs "Data.List" "L"
          , Builder.qualifiedAs "Data.List.NonEmpty" "NE"
          , Builder.qualifiedAs "Data.Char" "C"
          , Builder.qualifiedAs "Data.Aeson.Key" "Key"
          , Builder.qualifiedAs "Data.Aeson.KeyMap" "KeyMap"
          , Builder.qualifiedAs "Data.Vector" "V"
          , Builder.qualifiedAs "Data.Vector.Generic" "VG"
          , Builder.qualifiedAs "Data.Vector.Storable" "VS"
          , Builder.qualifiedAs "Data.Vector.Unboxed" "VU"
          ]
      ]

in  rules
