let Types = ../Types.dhall

let Builder = ../Builder.dhall

let useUnliftIOAsync
    : Text -> Text -> Types.Function
    = \(name : Text) ->
      \(problem : Text) ->
        Builder.restrictFunction name "${problem} Use UnliftIO.Async instead."

let useUnliftIOAsyncWith
    : Text -> Text -> Text -> Types.Function
    = \(name : Text) ->
      \(problem : Text) ->
      \(alternative : Text) ->
        Builder.restrictFunction
          name
          "${problem} Use ${alternative} from UnliftIO.Async instead."

let rules
    : List Types.Rule
    = [ Builder.functions
          [ useUnliftIOAsyncWith
              "forkIO"
              "Exceptions don't propagate to parent thread."
              "async or withAsync"
          , useUnliftIOAsyncWith
              "forkOS"
              "Exceptions don't propagate to parent thread."
              "asyncBound or withAsyncBound"
          , useUnliftIOAsyncWith
              "forkOn"
              "Exceptions don't propagate to parent thread."
              "asyncOn or withAsyncOn"
          , useUnliftIOAsyncWith
              "forkIOWithUnmask"
              "Exceptions don't propagate to parent thread."
              "asyncWithUnmask or withAsyncWithUnmask"
          , useUnliftIOAsyncWith
              "forkOnWithUnmask"
              "Exceptions don't propagate to parent thread."
              "asyncOnWithUnmask or withAsyncOnWithUnmask"
          , useUnliftIOAsyncWith
              "forkWithUnmask"
              "Deprecated and exceptions don't propagate to parent thread."
              "asyncWithUnmask or withAsyncWithUnmask"
          , useUnliftIOAsync
              "forkFinally"
              "No automatic cancellation or exception handling."
          , useUnliftIOAsync
              "killThread"
              "Prefer structured cancellation with cancel or withAsync."
          , Builder.restrictFunction
              "forkProcess"
              "Almost impossible to use correctly. Consider typed-process or UnliftIO.Async."
          ]
      ]

in  rules
