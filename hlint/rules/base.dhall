-- base library rules
-- `Control.Concurrent` and `Foreign` is covered by `unliftio.dhall`
-- `GHC` modules are excluded
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let debugTraceFunctions
    : List Types.Function
    = [ Builder.restrictInModule
          "Debug.Trace"
          "trace"
          "Debug function, not for production. Remove before release."
      , Builder.restrictInModule
          "Debug.Trace"
          "traceId"
          "Debug function, not for production. Remove before release."
      , Builder.restrictInModule
          "Debug.Trace"
          "traceShow"
          "Debug function, not for production. Remove before release."
      , Builder.restrictInModule
          "Debug.Trace"
          "traceShowId"
          "Debug function, not for production. Remove before release."
      , Builder.restrictInModule
          "Debug.Trace"
          "traceWith"
          "Debug function, not for production. Remove before release."
      , Builder.restrictInModule
          "Debug.Trace"
          "traceShowWith"
          "Debug function, not for production. Remove before release."
      , Builder.restrictInModule
          "Debug.Trace"
          "traceStack"
          "Debug function, not for production. Remove before release."
      , Builder.restrictInModule
          "Debug.Trace"
          "traceIO"
          "Debug function, not for production. Remove before release."
      , Builder.restrictInModule
          "Debug.Trace"
          "traceM"
          "Debug function, not for production. Remove before release."
      , Builder.restrictInModule
          "Debug.Trace"
          "traceShowM"
          "Debug function, not for production. Remove before release."
      , Builder.restrictInModule
          "Debug.Trace"
          "putTraceMsg"
          "Debug function, not for production. Remove before release."
      , Builder.restrictInModule
          "Debug.Trace"
          "traceEvent"
          "Debug function, not for production. Remove before release."
      , Builder.restrictInModule
          "Debug.Trace"
          "traceEventWith"
          "Debug function, not for production. Remove before release."
      , Builder.restrictInModule
          "Debug.Trace"
          "traceEventIO"
          "Debug function, not for production. Remove before release."
      , Builder.restrictInModule
          "Debug.Trace"
          "flushEventLog"
          "Debug function, not for production. Remove before release."
      , Builder.restrictInModule
          "Debug.Trace"
          "traceMarker"
          "Debug function, not for production. Remove before release."
      , Builder.restrictInModule
          "Debug.Trace"
          "traceMarkerIO"
          "Debug function, not for production. Remove before release."
      ]

let stUnsafeModules
    : List Types.Module
    = [ Builder.banModule
          "Control.Monad.ST.Unsafe"
          "Unsafe ST operations. Use Control.Monad.ST instead."
      , Builder.banModule
          "Control.Monad.ST.Lazy.Unsafe"
          "Unsafe lazy ST operations. Use Control.Monad.ST.Lazy instead."
      ]

let preludePartialFunctions
    : List Types.Function
    = [] : List Types.Function

let rules
    : List Types.Rule
    = [ Builder.functions debugTraceFunctions
      , Builder.modules stUnsafeModules
      , Builder.functions preludePartialFunctions
      ]

in  rules
