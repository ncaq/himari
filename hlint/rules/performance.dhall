-- パフォーマンス問題警告
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    : List Types.Rule
    = [ Builder.functions
          [ Builder.restrictFunction
              "nub"
              "O(n^2) complexity. Use ordNub or nubOrd instead."
          , Builder.restrictFunction
              "foldl"
              "Lazy accumulator causes space leaks. Use foldl' instead."
          , Builder.restrictFunction
              "genericLength"
              "O(n) stack space. Use length with explicit conversion."
          ]
      ]

in  rules
