-- qualified importのエイリアス名ガイドライン
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    : List Types.Rule
    = [ Builder.modules
          [ Builder.qualifiedAsRequired "Data.ByteString" "B"
          , Builder.qualifiedAsRequired "Data.ByteString.Char8" "B"
          , Builder.qualifiedAsRequired "Data.ByteString.Lazy" "BL"
          , Builder.qualifiedAsRequired "Data.ByteString.Lazy.Char8" "BL"
          , Builder.qualifiedAsRequired "Data.Text" "T"
          , Builder.qualifiedAsRequired "Data.Text.Lazy" "TL"
          , Builder.qualifiedAsRequired "Data.Map" "Map"
          , Builder.qualifiedAsRequired "Data.Map.Strict" "Map"
          , Builder.qualifiedAsRequired "Data.Map.Lazy" "Map"
          , Builder.qualifiedAsRequired "Data.Set" "Set"
          , Builder.qualifiedAsRequired "Data.Sequence" "Seq"
          , Builder.qualifiedAsRequired "Data.IntMap" "IntMap"
          , Builder.qualifiedAsRequired "Data.IntMap.Strict" "IntMap"
          , Builder.qualifiedAsRequired "Data.IntMap.Lazy" "IntMap"
          , Builder.qualifiedAsRequired "Data.IntSet" "IntSet"
          , Builder.qualifiedAsRequired "Data.HashMap.Strict" "HM"
          , Builder.qualifiedAsRequired "Data.HashMap.Lazy" "HM"
          , Builder.qualifiedAsRequired "Data.HashSet" "HS"
          , Builder.qualifiedAsRequired "Data.List" "L"
          , Builder.qualifiedAsRequired "Data.List.NonEmpty" "NE"
          , Builder.qualifiedAsRequired "Data.Char" "C"
          , Builder.qualifiedAsRequired "Data.Vector" "V"
          , Builder.qualifiedAsRequired "Data.Vector.Generic" "V"
          , Builder.qualifiedAsRequired "Data.Vector.Storable" "VS"
          , Builder.qualifiedAsRequired "Data.Vector.Unboxed" "VU"
          ]
      ]

in  rules
