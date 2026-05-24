-- Numeric module partial functions
-- These integer-showing functions throw on negative (or invalid base) input.
-- Names are unqualified so re-exports through Himari are caught as well.
-- The float-showing functions (showEFloat etc.) clamp negative precision and stay total.
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let showIntAtBaseMessage =
      "Partial: throws on base <= 1 or negative input. Ensure base > 1 and non-negative input."

let showIntAtBase =
      Builder.restrictFunction "showIntAtBase" showIntAtBaseMessage

let showIntMessage =
      "Partial: throws on negative numbers. Ensure non-negative input."

let showInt = Builder.restrictFunction "showInt" showIntMessage

let showHexMessage =
      "Partial: throws on negative numbers. Ensure non-negative input."

let showHex = Builder.restrictFunction "showHex" showHexMessage

let showOctMessage =
      "Partial: throws on negative numbers. Ensure non-negative input."

let showOct = Builder.restrictFunction "showOct" showOctMessage

let showBinMessage =
      "Partial: throws on negative numbers. Ensure non-negative input."

let showBin = Builder.restrictFunction "showBin" showBinMessage

let rules
    : List Types.Rule
    = [ Builder.functions [ showIntAtBase, showInt, showHex, showOct, showBin ]
      ]

in  rules
