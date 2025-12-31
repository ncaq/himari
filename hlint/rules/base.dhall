-- base library rules
-- `Control.Concurrent` and `Foreign` is covered by `unliftio.dhall`
-- `GHC` modules are excluded
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let stUnsafeModules
    : List Types.Module
    = [ Builder.banModule
          "Control.Monad.ST.Unsafe"
          "Unsafe ST operations. Use Control.Monad.ST instead."
      , Builder.banModule
          "Control.Monad.ST.Lazy.Unsafe"
          "Unsafe lazy ST operations. Use Control.Monad.ST.Lazy instead."
      ]

let rules
    : List Types.Rule
    = [ Builder.modules stUnsafeModules ]

in  rules
