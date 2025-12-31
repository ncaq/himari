let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    : List Types.Rule
    = [ Builder.functions
          [ Builder.restrictFunction
              "unsafePerformIO"
              "Breaks type safety. Only for very specific use cases."
          , Builder.restrictFunction
              "unsafeDupablePerformIO"
              "Even more dangerous than unsafePerformIO."
          , Builder.restrictFunction
              "unsafeInterleaveIO"
              "Creates lazy IO. Avoid."
          , Builder.restrictFunction
              "unsafeCoerce"
              "Can cause segfaults. Avoid."
          , Builder.restrictFunction
              "unsafeFixIO"
              "Unsafe version of fixIO. Avoid."
          ]
      ]

in  rules
