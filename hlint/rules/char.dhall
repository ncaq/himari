-- `Data.Char`の部分関数などに対する警告と、`Himari.Char`で安全な代替を提供していることへのガイド。
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let digitToIntMessage =
          "Partial: throws on non-hex-digit character. "
      ++  "Use digitToIntMay from Himari.Char which returns Maybe."

let digitToInt =
      Builder.restrictInModule "Data.Char" "digitToInt" digitToIntMessage

let intToDigitMessage =
          "Partial: throws on out-of-range (must be 0-15). "
      ++  "Use intToDigitMay from Himari.Char which returns Maybe."

let intToDigit =
      Builder.restrictInModule "Data.Char" "intToDigit" intToDigitMessage

let chrMessage =
      "Partial: throws on invalid code point. Use chrMay from Himari.Char which returns Maybe."

let chr = Builder.restrictInModule "Data.Char" "chr" chrMessage

let rules
    : List Types.Rule
    = [ Builder.functions [ digitToInt, intToDigit, chr ] ]

in  rules
