let Types = ../Types.dhall

let Builder = ../Builder.dhall

let spaceLeakModules =
      [ Builder.banModule
          "Control.Monad.Writer"
          "Replace with Control.Monad.Writer.CPS to avoid space leaks."
      , Builder.banModule
          "Control.Monad.Writer.Lazy"
          "Replace with Control.Monad.Writer.CPS to avoid space leaks."
      , Builder.banModule
          "Control.Monad.Writer.Strict"
          "Replace with Control.Monad.Writer.CPS to avoid space leaks."
      , Builder.banModule
          "Control.Monad.RWS"
          "Replace with Control.Monad.RWS.CPS to avoid space leaks."
      , Builder.banModule
          "Control.Monad.RWS.Lazy"
          "Replace with Control.Monad.RWS.CPS to avoid space leaks."
      , Builder.banModule
          "Control.Monad.RWS.Strict"
          "Replace with Control.Monad.RWS.CPS to avoid space leaks."
      ]

let redirectModules =
      [ Builder.banModule
          "Control.Monad.State"
          "Ambiguous: Use Control.Monad.State.Lazy or Control.Monad.State.Strict explicitly."
      , Builder.banModule
          "Control.Monad.Trans"
          "Redirect: Import Control.Monad.Trans.Class or Control.Monad.IO.Class directly."
      , Builder.banModule
          "Control.Monad.Identity"
          "Redirect: Import Data.Functor.Identity directly."
      ]

let rules
    : List Types.Rule
    = [ Builder.modules spaceLeakModules, Builder.modules redirectModules ]

in  rules
