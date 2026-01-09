let Prelude =
      https://prelude.dhall-lang.org/v23.1.0/package.dhall
        sha256:931cbfae9d746c4611b07633ab1e547637ab4ba138b16bf65ef1b9ad66a60b7f

let Types = ../Types.dhall

let Builder = ../Builder.dhall

let partialMonadic
    : Text -> Text -> Text -> Text -> Types.Function
    = \(module : Text) ->
      \(name : Text) ->
      \(condition : Text) ->
      \(alternative : Text) ->
        let message =
                  "Partial: throws on ${condition} regardless of Monad "
              ++  "(M is for evaluation control, not error handling). "
              ++  "Use ${alternative}."

        in  Builder.restrictInModule module name message

let partialBatchUpdate
    : Text -> Text -> Types.Function
    = \(module : Text) ->
      \(name : Text) ->
        Builder.restrictInModule
          module
          name
          "Partial: throws on out-of-bounds indices. Validate indices against length or use modify."

let immutableModules =
      [ "Data.Vector"
      , "Data.Vector.Generic"
      , "Data.Vector.Primitive"
      , "Data.Vector.Storable"
      , "Data.Vector.Strict"
      , "Data.Vector.Unboxed"
      ]

let mutableModules =
      [ "Data.Vector.Mutable"
      , "Data.Vector.Generic.Mutable"
      , "Data.Vector.Primitive.Mutable"
      , "Data.Vector.Storable.Mutable"
      , "Data.Vector.Strict.Mutable"
      , "Data.Vector.Unboxed.Mutable"
      ]

let partialImmutable
    : Text -> List Types.Function
    = \(module : Text) ->
        [ Builder.restrictInModule
            module
            "!"
            "Partial: throws on out-of-bounds. Use (!?) for safe indexing."
        , Builder.restrictInModule
            module
            "head"
            "Partial: throws on empty vector. Use uncons or (!?) 0 instead."
        , Builder.restrictInModule
            module
            "last"
            "Partial: throws on empty vector. Use unsnoc or check null first."
        , partialMonadic
            module
            "indexM"
            "out-of-bounds"
            "(!?) for safe indexing"
        , partialMonadic
            module
            "headM"
            "empty vector"
            "uncons or check null first"
        , partialMonadic
            module
            "lastM"
            "empty vector"
            "unsnoc or check null first"
        , Builder.restrictInModule
            module
            "init"
            "Partial: throws on empty vector. Use unsnoc for safe init."
        , Builder.restrictInModule
            module
            "tail"
            "Partial: throws on empty vector. Use uncons for safe tail."
        , partialBatchUpdate module "//"
        , partialBatchUpdate module "update"
        , partialBatchUpdate module "update_"
        , partialBatchUpdate module "accum"
        , partialBatchUpdate module "accumulate"
        , partialBatchUpdate module "accumulate_"
        , partialBatchUpdate module "backpermute"
        , Builder.restrictInModule
            module
            "foldl1"
            "Partial: throws on empty vector. Use foldl with explicit initial value."
        , Builder.restrictInModule
            module
            "foldl1'"
            "Partial: throws on empty vector. Use foldl' with explicit initial value."
        , Builder.restrictInModule
            module
            "foldr1"
            "Partial: throws on empty vector. Use foldr with explicit initial value."
        , Builder.restrictInModule
            module
            "foldr1'"
            "Partial: throws on empty vector. Use foldr' with explicit initial value."
        , Builder.restrictInModule
            module
            "maximum"
            "Partial: throws on empty vector. Use fold with explicit initial value."
        , Builder.restrictInModule
            module
            "maximumBy"
            "Partial: throws on empty vector. Use fold with explicit initial value."
        , Builder.restrictInModule
            module
            "minimum"
            "Partial: throws on empty vector. Use fold with explicit initial value."
        , Builder.restrictInModule
            module
            "minimumBy"
            "Partial: throws on empty vector. Use fold with explicit initial value."
        , Builder.restrictInModule
            module
            "minIndex"
            "Partial: throws on empty vector. Use indexed fold with Maybe result."
        , Builder.restrictInModule
            module
            "minIndexBy"
            "Partial: throws on empty vector. Use indexed fold with Maybe result."
        , Builder.restrictInModule
            module
            "maxIndex"
            "Partial: throws on empty vector. Use indexed fold with Maybe result."
        , Builder.restrictInModule
            module
            "maxIndexBy"
            "Partial: throws on empty vector. Use indexed fold with Maybe result."
        , Builder.restrictInModule
            module
            "fold1M"
            "Partial: throws on empty vector. Use foldM with explicit initial value."
        , Builder.restrictInModule
            module
            "fold1M'"
            "Partial: throws on empty vector. Use foldM' with explicit initial value."
        , Builder.restrictInModule
            module
            "fold1M_"
            "Partial: throws on empty vector. Use foldM_ with explicit initial value."
        , Builder.restrictInModule
            module
            "fold1M'_"
            "Partial: throws on empty vector. Use foldM'_ with explicit initial value."
        , Builder.restrictInModule
            module
            "scanl1"
            "Partial: throws on empty vector. Use scanl with explicit initial value."
        , Builder.restrictInModule
            module
            "scanl1'"
            "Partial: throws on empty vector. Use scanl' with explicit initial value."
        , Builder.restrictInModule
            module
            "scanr1"
            "Partial: throws on empty vector. Use scanr with explicit initial value."
        , Builder.restrictInModule
            module
            "scanr1'"
            "Partial: throws on empty vector. Use scanr' with explicit initial value."
        ]

let unsafeImmutable
    : Text -> List Types.Function
    = \(module : Text) ->
        [ Builder.restrictInModule
            module
            "unsafeIndex"
            "Unsafe: no bounds checking, may cause segfaults. Use (!) or (!?) instead."
        , Builder.restrictInModule
            module
            "unsafeHead"
            "Unsafe: no empty check, may cause segfaults. Use uncons or (!?) 0 instead."
        , Builder.restrictInModule
            module
            "unsafeLast"
            "Unsafe: no empty check, may cause segfaults. Use unsnoc or check null first."
        , Builder.restrictInModule
            module
            "unsafeIndexM"
            "Unsafe: no bounds checking, may cause segfaults. Use (!?) instead."
        , Builder.restrictInModule
            module
            "unsafeHeadM"
            "Unsafe: no empty check, may cause segfaults. Use uncons or (!?) 0 instead."
        , Builder.restrictInModule
            module
            "unsafeLastM"
            "Unsafe: no empty check, may cause segfaults. Use unsnoc or check null first."
        , Builder.restrictInModule
            module
            "unsafeSlice"
            "Unsafe: no bounds checking, may cause segfaults. Use slice instead."
        , Builder.restrictInModule
            module
            "unsafeInit"
            "Unsafe: no empty check, may cause segfaults. Use unsnoc instead."
        , Builder.restrictInModule
            module
            "unsafeTail"
            "Unsafe: no empty check, may cause segfaults. Use uncons instead."
        , Builder.restrictInModule
            module
            "unsafeTake"
            "Unsafe: no bounds checking, may cause segfaults. Use take instead."
        , Builder.restrictInModule
            module
            "unsafeDrop"
            "Unsafe: no bounds checking, may cause segfaults. Use drop instead."
        , Builder.restrictInModule
            module
            "unsafeUpd"
            "Unsafe: no bounds checking, may cause segfaults. Use (//) instead."
        , Builder.restrictInModule
            module
            "unsafeUpdate"
            "Unsafe: no bounds checking, may cause segfaults. Use update instead."
        , Builder.restrictInModule
            module
            "unsafeUpdate_"
            "Unsafe: no bounds checking, may cause segfaults. Use update_ instead."
        , Builder.restrictInModule
            module
            "unsafeAccum"
            "Unsafe: no bounds checking, may cause segfaults. Use accum instead."
        , Builder.restrictInModule
            module
            "unsafeAccumulate"
            "Unsafe: no bounds checking, may cause segfaults. Use accumulate instead."
        , Builder.restrictInModule
            module
            "unsafeAccumulate_"
            "Unsafe: no bounds checking, may cause segfaults. Use accumulate_ instead."
        , Builder.restrictInModule
            module
            "unsafeBackpermute"
            "Unsafe: no bounds checking, may cause segfaults. Use backpermute instead."
        , Builder.restrictInModule
            module
            "unsafeFreeze"
            "Unsafe: the mutable vector may not be used after this. Use freeze for safety."
        , Builder.restrictInModule
            module
            "unsafeThaw"
            "Unsafe: the immutable vector may not be used after this. Use thaw for safety."
        , Builder.restrictInModule
            module
            "unsafeCopy"
            "Unsafe: no length checking. Use copy for safety."
        ]

let partialMutable
    : Text -> List Types.Function
    = \(module : Text) ->
        [ Builder.restrictInModule
            module
            "init"
            "Partial: throws on empty vector. Use unsafeInit only if you've verified non-empty."
        , Builder.restrictInModule
            module
            "tail"
            "Partial: throws on empty vector. Use unsafeTail only if you've verified non-empty."
        ]

let unsafeMutable
    : Text -> List Types.Function
    = \(module : Text) ->
        [ Builder.restrictInModule
            module
            "unsafeSlice"
            "Unsafe: no bounds checking, may cause segfaults. Use slice instead."
        , Builder.restrictInModule
            module
            "unsafeInit"
            "Unsafe: no empty check, may cause segfaults. Verify non-empty first."
        , Builder.restrictInModule
            module
            "unsafeTail"
            "Unsafe: no empty check, may cause segfaults. Verify non-empty first."
        , Builder.restrictInModule
            module
            "unsafeTake"
            "Unsafe: no bounds checking, may cause segfaults. Use take instead."
        , Builder.restrictInModule
            module
            "unsafeDrop"
            "Unsafe: no bounds checking, may cause segfaults. Use drop instead."
        , Builder.restrictInModule
            module
            "unsafeRead"
            "Unsafe: no bounds checking, may cause segfaults. Use read instead."
        , Builder.restrictInModule
            module
            "unsafeWrite"
            "Unsafe: no bounds checking, may cause segfaults. Use write instead."
        , Builder.restrictInModule
            module
            "unsafeModify"
            "Unsafe: no bounds checking, may cause segfaults. Use modify instead."
        , Builder.restrictInModule
            module
            "unsafeModifyM"
            "Unsafe: no bounds checking, may cause segfaults. Use modifyM instead."
        , Builder.restrictInModule
            module
            "unsafeSwap"
            "Unsafe: no bounds checking, may cause segfaults. Use swap instead."
        , Builder.restrictInModule
            module
            "unsafeExchange"
            "Unsafe: no bounds checking, may cause segfaults. Use exchange instead."
        , Builder.restrictInModule
            module
            "unsafeCopy"
            "Unsafe: no length/overlap checking. Use copy for safety."
        , Builder.restrictInModule
            module
            "unsafeMove"
            "Unsafe: no length checking. Use move for safety."
        , Builder.restrictInModule
            module
            "unsafeGrow"
            "Unsafe: no non-negative check. Use grow for safety."
        , Builder.restrictInModule
            module
            "unsafeNew"
            "Unsafe: elements are uninitialized and may cause exceptions. Use new or replicate instead."
        ]

let unsafeGenericMutableExtra
    : List Types.Function
    = [ Builder.restrictInModule
          "Data.Vector.Generic.Mutable"
          "unsafeGrowFront"
          "Unsafe: no non-negative check. Use growFront for safety."
      , Builder.restrictInModule
          "Data.Vector.Generic.Mutable"
          "unsafeAccum"
          "Unsafe: no bounds checking, may cause segfaults. Use accum for safety."
      , Builder.restrictInModule
          "Data.Vector.Generic.Mutable"
          "unsafeUpdate"
          "Unsafe: no bounds checking, may cause segfaults. Use update for safety."
      ]

let unsafePrimitiveMutableExtra
    : List Types.Function
    = [ Builder.restrictInModule
          "Data.Vector.Primitive.Mutable"
          "unsafeCast"
          "Unsafe: type cast without memory safety guarantees. Ensure correct memory layout."
      , Builder.restrictInModule
          "Data.Vector.Primitive.Mutable"
          "unsafeCoerceMVector"
          "Unsafe: coerces vector type without safety checks."
      ]

let unsafeStorableMutableExtra
    : List Types.Function
    = [ Builder.restrictInModule
          "Data.Vector.Storable.Mutable"
          "unsafeCast"
          "Unsafe: type cast without memory safety guarantees. Ensure correct memory layout."
      , Builder.restrictInModule
          "Data.Vector.Storable.Mutable"
          "unsafeCoerceMVector"
          "Unsafe: coerces vector type without safety checks."
      , Builder.restrictInModule
          "Data.Vector.Storable.Mutable"
          "unsafeFromForeignPtr"
          "Unsafe: creates vector from raw pointer without validation."
      , Builder.restrictInModule
          "Data.Vector.Storable.Mutable"
          "unsafeFromForeignPtr0"
          "Unsafe: creates vector from raw pointer without validation."
      , Builder.restrictInModule
          "Data.Vector.Storable.Mutable"
          "unsafeToForeignPtr"
          "Unsafe: extracts raw pointer, vector may not be used safely after."
      , Builder.restrictInModule
          "Data.Vector.Storable.Mutable"
          "unsafeToForeignPtr0"
          "Unsafe: extracts raw pointer, vector may not be used safely after."
      , Builder.restrictInModule
          "Data.Vector.Storable.Mutable"
          "unsafeWith"
          "Unsafe: passes raw pointer to IO action without safety guarantees."
      ]

let immutablePartialFuncs
    : List Types.Function
    = Prelude.List.concat
        Types.Function
        ( Prelude.List.map
            Text
            (List Types.Function)
            partialImmutable
            immutableModules
        )

let immutableUnsafeFuncs
    : List Types.Function
    = Prelude.List.concat
        Types.Function
        ( Prelude.List.map
            Text
            (List Types.Function)
            unsafeImmutable
            immutableModules
        )

let mutablePartialFuncs
    : List Types.Function
    = Prelude.List.concat
        Types.Function
        ( Prelude.List.map
            Text
            (List Types.Function)
            partialMutable
            mutableModules
        )

let mutableUnsafeFuncs
    : List Types.Function
    = Prelude.List.concat
        Types.Function
        ( Prelude.List.map
            Text
            (List Types.Function)
            unsafeMutable
            mutableModules
        )

let rules
    : List Types.Rule
    = [ Builder.functions immutablePartialFuncs
      , Builder.functions immutableUnsafeFuncs
      , Builder.functions mutablePartialFuncs
      , Builder.functions
          (   mutableUnsafeFuncs
            # unsafeGenericMutableExtra
            # unsafePrimitiveMutableExtra
            # unsafeStorableMutableExtra
          )
      ]

in  rules
