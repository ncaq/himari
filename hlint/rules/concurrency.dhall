let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    : List Types.Rule
    = [ Builder.functions
          [ Builder.restrictFunction
              "forkIO"
              "Exceptions don't propagate to parent thread. Use async or withAsync from UnliftIO.Async instead."
          , Builder.restrictFunction
              "forkOS"
              "Exceptions don't propagate to parent thread. Use asyncBound or withAsyncBound from UnliftIO.Async instead."
          , Builder.restrictFunction
              "forkOn"
              "Exceptions don't propagate to parent thread. Use asyncOn or withAsyncOn from UnliftIO.Async instead."
          , Builder.restrictFunction
              "forkIOWithUnmask"
              "Exceptions don't propagate to parent thread. Use asyncWithUnmask or withAsyncWithUnmask from UnliftIO.Async instead."
          , Builder.restrictFunction
              "forkOnWithUnmask"
              "Exceptions don't propagate to parent thread. Use asyncWithUnmask or withAsyncWithUnmask from UnliftIO.Async instead."
          , Builder.restrictFunction
              "forkWithUnmask"
              "Deprecated and exceptions don't propagate. Use asyncWithUnmask or withAsyncWithUnmask from UnliftIO.Async instead."
          , Builder.restrictFunction
              "forkFinally"
              "Use withAsync from UnliftIO.Async for automatic cancellation and exception handling."
          , Builder.restrictFunction
              "killThread"
              "Prefer structured cancellation with cancel or withAsync from UnliftIO.Async."
          , Builder.restrictFunction
              "forkProcess"
              "Almost impossible to use correctly. Consider using typed-process or UnliftIO.Async."
          ]
      ]

in  rules
