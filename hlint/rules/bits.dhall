-- Data.Bits部分関数警告
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    : List Types.Rule
    = [ Builder.functions
          [ Builder.restrictInModule
              "Data.Bits"
              "bitSize"
              "Deprecated and partial. Use bitSizeMaybe or finiteBitSize instead."
          , Builder.restrictInModule
              "Data.Bits"
              "unsafeShiftL"
              "Undefined for negative or overflow shift."
          , Builder.restrictInModule
              "Data.Bits"
              "unsafeShiftR"
              "Undefined for negative or overflow shift."
          , Builder.restrictInModule
              "Data.Bits"
              "rotateL"
              "Undefined for negative rotation."
          , Builder.restrictInModule
              "Data.Bits"
              "rotateR"
              "Undefined for negative rotation."
          ]
      ]

in  rules
