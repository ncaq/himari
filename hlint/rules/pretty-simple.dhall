-- Prefer `Debug.Pretty.Simple` functions over `Debug.Trace` for better output
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let note = Some "pTrace* provides pretty-printed output for easier debugging"

let traceReplacements
    : List Types.Rule
    = [ Builder.hint "trace" "pTrace" note
      , Builder.hint "traceId" "pTraceId" note
      , Builder.hint "traceShow" "pTraceShow" note
      , Builder.hint "traceShowId" "pTraceShowId" note
      , Builder.hint "traceWith" "pTraceWith" note
      , Builder.hint "traceShowWith" "pTraceShowWith" note
      , Builder.hint "traceStack" "pTraceStack" note
      , Builder.hint "traceIO" "pTraceIO" note
      , Builder.hint "traceM" "pTraceM" note
      , Builder.hint "traceShowM" "pTraceShowM" note
      , Builder.hint "traceEvent" "pTraceEvent" note
      , Builder.hint "traceEventIO" "pTraceEventIO" note
      , Builder.hint "traceMarker" "pTraceMarker" note
      , Builder.hint "traceMarkerIO" "pTraceMarkerIO" note
      ]

in  traceReplacements
