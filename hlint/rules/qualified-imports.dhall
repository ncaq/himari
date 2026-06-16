-- qualified importのエイリアス名ガイドライン
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let byteString = Builder.qualifiedAs "Data.ByteString" "B"

let byteStringChar8 = Builder.qualifiedAs "Data.ByteString.Char8" "B8"

let byteStringLazy = Builder.qualifiedAs "Data.ByteString.Lazy" "BL"

let byteStringLazyChar8 = Builder.qualifiedAs "Data.ByteString.Lazy.Char8" "BL8"

let text = Builder.qualifiedAs "Data.Text" "T"

let textLazy = Builder.qualifiedAs "Data.Text.Lazy" "TL"

let mapMessage =
          "Data.Map is a re-export of Data.Map.Lazy. "
      ++  "Use Data.Map.Strict or Data.Map.Lazy directly."

let map = Builder.banModule "Data.Map" mapMessage

let mapStrict = Builder.qualifiedAs "Data.Map.Strict" "Map"

let mapLazy = Builder.qualifiedAs "Data.Map.Lazy" "MapL"

let intMapMessage =
          "Data.IntMap is a re-export of Data.IntMap.Lazy. "
      ++  "Use Data.IntMap.Strict or Data.IntMap.Lazy directly."

let intMap = Builder.banModule "Data.IntMap" intMapMessage

let intMapStrict = Builder.qualifiedAs "Data.IntMap.Strict" "IntMap"

let intMapLazy = Builder.qualifiedAs "Data.IntMap.Lazy" "IntMapL"

let set = Builder.qualifiedAs "Data.Set" "Set"

let sequence = Builder.qualifiedAs "Data.Sequence" "Seq"

let intSet = Builder.qualifiedAs "Data.IntSet" "IntSet"

let hashMapStrict = Builder.qualifiedAs "Data.HashMap.Strict" "HM"

let hashMapLazy = Builder.qualifiedAs "Data.HashMap.Lazy" "HML"

let hashSet = Builder.qualifiedAs "Data.HashSet" "HS"

let list = Builder.qualifiedAs "Data.List" "L"

let listUtils = Builder.qualifiedAs "Data.Containers.ListUtils" "L"

let nonEmpty = Builder.qualifiedAs "Data.List.NonEmpty" "NE"

let char = Builder.qualifiedAs "Data.Char" "C"

let aesonKey = Builder.qualifiedAs "Data.Aeson.Key" "Key"

let aesonKeyMap = Builder.qualifiedAs "Data.Aeson.KeyMap" "KeyMap"

let vector = Builder.qualifiedAs "Data.Vector" "V"

let vectorGeneric = Builder.qualifiedAs "Data.Vector.Generic" "VG"

let vectorStorable = Builder.qualifiedAs "Data.Vector.Storable" "VS"

let vectorUnboxed = Builder.qualifiedAs "Data.Vector.Unboxed" "VU"

let rules
    : List Types.Rule
    = [ Builder.modules
          [ byteString
          , byteStringChar8
          , byteStringLazy
          , byteStringLazyChar8
          , text
          , textLazy
          , map
          , mapStrict
          , mapLazy
          , intMap
          , intMapStrict
          , intMapLazy
          , set
          , sequence
          , intSet
          , hashMapStrict
          , hashMapLazy
          , hashSet
          , list
          , listUtils
          , nonEmpty
          , char
          , aesonKey
          , aesonKeyMap
          , vector
          , vectorGeneric
          , vectorStorable
          , vectorUnboxed
          ]
      ]

in  rules
