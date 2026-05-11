let Types = ../Types.dhall

let Builder = ../Builder.dhall

let throwMessage = "Don't throw in pure code. Use throwM in MonadThrow context."

let throw = Builder.restrictFunction "throw" throwMessage

let throwStringMessage =
      "Use typed exceptions with throwM instead of throwString."

let throwString = Builder.restrictFunction "throwString" throwStringMessage

let throwIOMessage = "Use typed exceptions with throwM instead of throwIO."

let throwIO = Builder.restrictFunction "throwIO" throwIOMessage

let errorMessage =
          "Avoid in production code. "
      ++  "For development placeholders, consider typed holes instead."

let error = Builder.restrictFunction "error" errorMessage

let undefinedMessage =
          "Remember to implement before release. "
      ++  "Consider typed holes for better error messages."

let undefined = Builder.restrictFunction "undefined" undefinedMessage

let errorWithoutStackTraceMessage = "Use proper error handling"

let errorWithoutStackTrace =
      Builder.restrictFunction
        "errorWithoutStackTrace"
        errorWithoutStackTraceMessage

let errorWithStackTraceMessage =
      "Deprecated. Use error instead, which now includes stack traces."

let errorWithStackTrace =
      Builder.restrictFunction "errorWithStackTrace" errorWithStackTraceMessage

let rules
    : List Types.Rule
    = [ Builder.functions
          [ throw
          , throwString
          , throwIO
          , error
          , undefined
          , errorWithoutStackTrace
          , errorWithStackTrace
          ]
      ]

in  rules
