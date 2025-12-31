let Types = ../Types.dhall

let Builder = ../Builder.dhall

let partialLensFuncs =
      [ Builder.restrictFunction
          "Control.Lens.Fold.^?!"
          "Partial: throws on empty Fold. Use (^?) instead."
      , Builder.restrictFunction
          "Control.Lens.Fold.^@?!"
          "Partial: throws on empty Fold. Use (^@?) instead."
      , Builder.restrictInModule
          "Control.Lens.Traversal"
          "singular"
          "Partial: throws on 0 or >1 elements. Consider using (^?) or ensure exactly 1 element."
      , Builder.restrictInModule
          "Control.Lens.Traversal"
          "unsafeSingular"
          "Partial: throws on 0 or >1 elements."
      , Builder.restrictInModule
          "Control.Lens.Traversal"
          "unsafePartsOf"
          "Unsafe: may throw if list length changes."
      , Builder.restrictInModule
          "Control.Lens.Traversal"
          "iunsafePartsOf"
          "Unsafe: may throw if list length changes."
      ]

let unsoundLensFuncs =
      [ Builder.restrictInModule
          "Control.Lens.Unsound"
          "lensProduct"
          "Unsound: violates lens laws unless lenses are disjoint. Use alongside instead."
      , Builder.restrictInModule
          "Control.Lens.Unsound"
          "prismSum"
          "Unsound: violates prism laws. Use without instead."
      , Builder.restrictInModule
          "Control.Lens.Unsound"
          "adjoin"
          "Unsound: violates traversal laws unless traversals are disjoint. Use failing instead."
      ]

let rules
    : List Types.Rule
    = [ Builder.functions partialLensFuncs, Builder.functions unsoundLensFuncs ]

in  rules
