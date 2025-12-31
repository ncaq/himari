-- `Data.Char`の部分関数などに対する警告と、`Himari.Char`で安全な代替を提供していることへのガイド。
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    : List Types.Rule
    = [ Builder.functions
          [ Builder.restrictInModule
              "Data.Char"
              "digitToInt"
              "Partial: throws on non-hex-digit character. Use digitToIntMay from Himari.Char which returns Maybe."
          , Builder.restrictInModule
              "Data.Char"
              "intToDigit"
              "Partial: throws on out-of-range (must be 0-15). Use intToDigitMay from Himari.Char which returns Maybe."
          , Builder.restrictInModule
              "Data.Char"
              "chr"
              "Partial: throws on invalid code point. Use chrMay from Himari.Char which returns Maybe."
          ]
      ]

in  rules
