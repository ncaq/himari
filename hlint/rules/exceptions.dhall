let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    : List Types.Rule
    = [ Builder.functions
          [ Builder.restrictFunction
              "throw"
              "Don't throw in pure code. Use throwM in MonadThrow context."
          , Builder.restrictFunction
              "throwString"
              "Use typed exceptions with throwM instead of throwString."
          , Builder.restrictFunction
              "throwIO"
              "Use typed exceptions with throwM instead of throwIO."
          , Builder.restrictFunction
              "error"
              "Avoid in production code. For development placeholders, consider typed holes instead."
          , Builder.restrictFunction
              "undefined"
              "Remember to implement before release. Consider typed holes for better error messages."
          , Builder.restrictFunction
              "errorWithoutStackTrace"
              "Use proper error handling"
          ]
      ]

in  rules
