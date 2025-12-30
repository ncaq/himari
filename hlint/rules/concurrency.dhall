-- 並行処理警告
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    : List Types.Rule
    = [ Builder.functions
          [ Builder.restrictFunction
              "forkIO"
              "Exceptions don't propagate to parent thread. Use async library."
          , Builder.restrictFunction
              "forkProcess"
              "Almost impossible to use correctly. Use async library."
          ]
      ]

in  rules
