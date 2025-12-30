-- Data.Vector部分関数・unsafe関数警告
let Types = ../Types.dhall

let Builder = ../Builder.dhall

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

let mkFunc
    : Text -> Text -> Text -> Types.Function
    = \(module : Text) ->
      \(func : Text) ->
      \(message : Text) ->
        { name = "${module}.${func}", within = [] : List Text, message }

let partialImmutable
    : Text -> List Types.Function
    = \(module : Text) ->
        [ mkFunc
            module
            "!"
            "Partial: throws on out-of-bounds. Use (!?) for safe indexing."
        , mkFunc
            module
            "head"
            "Partial: throws on empty vector. Use uncons or (!?) 0 instead."
        , mkFunc
            module
            "last"
            "Partial: throws on empty vector. Use unsnoc or check null first."
        , mkFunc
            module
            "indexM"
            "Partial: throws exception on out-of-bounds regardless of Monad (M is for evaluation control, not error handling). Use (!?) for safe indexing."
        , mkFunc
            module
            "headM"
            "Partial: throws exception on empty vector regardless of Monad (M is for evaluation control, not error handling). Use uncons or check null first."
        , mkFunc
            module
            "lastM"
            "Partial: throws exception on empty vector regardless of Monad (M is for evaluation control, not error handling). Use unsnoc or check null first."
        , mkFunc
            module
            "init"
            "Partial: throws on empty vector. Use unsnoc for safe init."
        , mkFunc
            module
            "tail"
            "Partial: throws on empty vector. Use uncons for safe tail."
        , mkFunc
            module
            "//"
            "Partial: throws on out-of-bounds indices. Validate indices against length, or use modify with bounds checking."
        , mkFunc
            module
            "update"
            "Partial: throws on out-of-bounds indices. Validate indices against length, or use modify with bounds checking."
        , mkFunc
            module
            "update_"
            "Partial: throws on out-of-bounds indices. Validate indices against length, or use modify with bounds checking."
        , mkFunc
            module
            "accum"
            "Partial: throws on out-of-bounds indices. Validate indices against length, or use modify with bounds checking."
        , mkFunc
            module
            "accumulate"
            "Partial: throws on out-of-bounds indices. Validate indices against length, or use modify with bounds checking."
        , mkFunc
            module
            "accumulate_"
            "Partial: throws on out-of-bounds indices. Validate indices against length, or use modify with bounds checking."
        , mkFunc
            module
            "backpermute"
            "Partial: throws on out-of-bounds indices. Validate indices against length, or use modify with bounds checking."
        , mkFunc
            module
            "foldl1"
            "Partial: throws on empty vector. Use foldl with explicit initial value."
        , mkFunc
            module
            "foldl1'"
            "Partial: throws on empty vector. Use foldl' with explicit initial value."
        , mkFunc
            module
            "foldr1"
            "Partial: throws on empty vector. Use foldr with explicit initial value."
        , mkFunc
            module
            "foldr1'"
            "Partial: throws on empty vector. Use foldr' with explicit initial value."
        , mkFunc
            module
            "maximum"
            "Partial: throws on empty vector. Use fold with explicit initial value."
        , mkFunc
            module
            "maximumBy"
            "Partial: throws on empty vector. Use fold with explicit initial value."
        , mkFunc
            module
            "minimum"
            "Partial: throws on empty vector. Use fold with explicit initial value."
        , mkFunc
            module
            "minimumBy"
            "Partial: throws on empty vector. Use fold with explicit initial value."
        , mkFunc
            module
            "minIndex"
            "Partial: throws on empty vector. Use indexed fold with Maybe result."
        , mkFunc
            module
            "minIndexBy"
            "Partial: throws on empty vector. Use indexed fold with Maybe result."
        , mkFunc
            module
            "maxIndex"
            "Partial: throws on empty vector. Use indexed fold with Maybe result."
        , mkFunc
            module
            "maxIndexBy"
            "Partial: throws on empty vector. Use indexed fold with Maybe result."
        , mkFunc
            module
            "fold1M"
            "Partial: throws on empty vector. Use foldM with explicit initial value."
        , mkFunc
            module
            "fold1M'"
            "Partial: throws on empty vector. Use foldM' with explicit initial value."
        , mkFunc
            module
            "fold1M_"
            "Partial: throws on empty vector. Use foldM_ with explicit initial value."
        , mkFunc
            module
            "fold1M'_"
            "Partial: throws on empty vector. Use foldM'_ with explicit initial value."
        , mkFunc
            module
            "scanl1"
            "Partial: throws on empty vector. Use scanl with explicit initial value."
        , mkFunc
            module
            "scanl1'"
            "Partial: throws on empty vector. Use scanl' with explicit initial value."
        , mkFunc
            module
            "scanr1"
            "Partial: throws on empty vector. Use scanr with explicit initial value."
        , mkFunc
            module
            "scanr1'"
            "Partial: throws on empty vector. Use scanr' with explicit initial value."
        ]

let unsafeImmutable
    : Text -> List Types.Function
    = \(module : Text) ->
        [ mkFunc
            module
            "unsafeIndex"
            "Unsafe: no bounds checking, may cause segfaults. Use (!) or (!?) instead."
        , mkFunc
            module
            "unsafeHead"
            "Unsafe: no empty check, may cause segfaults. Use uncons or (!?) 0 instead."
        , mkFunc
            module
            "unsafeLast"
            "Unsafe: no empty check, may cause segfaults. Use unsnoc or check null first."
        , mkFunc
            module
            "unsafeIndexM"
            "Unsafe: no bounds checking, may cause segfaults. Use (!?) instead."
        , mkFunc
            module
            "unsafeHeadM"
            "Unsafe: no empty check, may cause segfaults. Use uncons or (!?) 0 instead."
        , mkFunc
            module
            "unsafeLastM"
            "Unsafe: no empty check, may cause segfaults. Use unsnoc or check null first."
        , mkFunc
            module
            "unsafeSlice"
            "Unsafe: no bounds checking, may cause segfaults. Use slice instead."
        , mkFunc
            module
            "unsafeInit"
            "Unsafe: no empty check, may cause segfaults. Use unsnoc instead."
        , mkFunc
            module
            "unsafeTail"
            "Unsafe: no empty check, may cause segfaults. Use uncons instead."
        , mkFunc
            module
            "unsafeTake"
            "Unsafe: no bounds checking, may cause segfaults. Use take instead."
        , mkFunc
            module
            "unsafeDrop"
            "Unsafe: no bounds checking, may cause segfaults. Use drop instead."
        , mkFunc
            module
            "unsafeUpd"
            "Unsafe: no bounds checking, may cause segfaults. Use (//) instead."
        , mkFunc
            module
            "unsafeUpdate"
            "Unsafe: no bounds checking, may cause segfaults. Use update instead."
        , mkFunc
            module
            "unsafeUpdate_"
            "Unsafe: no bounds checking, may cause segfaults. Use update_ instead."
        , mkFunc
            module
            "unsafeAccum"
            "Unsafe: no bounds checking, may cause segfaults. Use accum instead."
        , mkFunc
            module
            "unsafeAccumulate"
            "Unsafe: no bounds checking, may cause segfaults. Use accumulate instead."
        , mkFunc
            module
            "unsafeAccumulate_"
            "Unsafe: no bounds checking, may cause segfaults. Use accumulate_ instead."
        , mkFunc
            module
            "unsafeBackpermute"
            "Unsafe: no bounds checking, may cause segfaults. Use backpermute instead."
        , mkFunc
            module
            "unsafeFreeze"
            "Unsafe: the mutable vector may not be used after this. Use freeze for safety."
        , mkFunc
            module
            "unsafeThaw"
            "Unsafe: the immutable vector may not be used after this. Use thaw for safety."
        , mkFunc
            module
            "unsafeCopy"
            "Unsafe: no length checking. Use copy for safety."
        ]

let partialMutable
    : Text -> List Types.Function
    = \(module : Text) ->
        [ mkFunc
            module
            "init"
            "Partial: throws on empty vector. Use unsafeInit only if you've verified non-empty."
        , mkFunc
            module
            "tail"
            "Partial: throws on empty vector. Use unsafeTail only if you've verified non-empty."
        ]

let unsafeMutable
    : Text -> List Types.Function
    = \(module : Text) ->
        [ mkFunc
            module
            "unsafeSlice"
            "Unsafe: no bounds checking, may cause segfaults. Use slice instead."
        , mkFunc
            module
            "unsafeInit"
            "Unsafe: no empty check, may cause segfaults. Verify non-empty first."
        , mkFunc
            module
            "unsafeTail"
            "Unsafe: no empty check, may cause segfaults. Verify non-empty first."
        , mkFunc
            module
            "unsafeTake"
            "Unsafe: no bounds checking, may cause segfaults. Use take instead."
        , mkFunc
            module
            "unsafeDrop"
            "Unsafe: no bounds checking, may cause segfaults. Use drop instead."
        , mkFunc
            module
            "unsafeRead"
            "Unsafe: no bounds checking, may cause segfaults. Use read instead."
        , mkFunc
            module
            "unsafeWrite"
            "Unsafe: no bounds checking, may cause segfaults. Use write instead."
        , mkFunc
            module
            "unsafeModify"
            "Unsafe: no bounds checking, may cause segfaults. Use modify instead."
        , mkFunc
            module
            "unsafeModifyM"
            "Unsafe: no bounds checking, may cause segfaults. Use modifyM instead."
        , mkFunc
            module
            "unsafeSwap"
            "Unsafe: no bounds checking, may cause segfaults. Use swap instead."
        , mkFunc
            module
            "unsafeExchange"
            "Unsafe: no bounds checking, may cause segfaults. Use exchange instead."
        , mkFunc
            module
            "unsafeCopy"
            "Unsafe: no length/overlap checking. Use copy for safety."
        , mkFunc
            module
            "unsafeMove"
            "Unsafe: no length checking. Use move for safety."
        , mkFunc
            module
            "unsafeGrow"
            "Unsafe: no non-negative check. Use grow for safety."
        , mkFunc
            module
            "unsafeNew"
            "Unsafe: elements are uninitialized and may cause exceptions. Use new or replicate instead."
        ]

let unsafeGenericMutableExtra
    : List Types.Function
    = [ mkFunc
          "Data.Vector.Generic.Mutable"
          "unsafeGrowFront"
          "Unsafe: no non-negative check. Use growFront for safety."
      , mkFunc
          "Data.Vector.Generic.Mutable"
          "unsafeAccum"
          "Unsafe: no bounds checking, may cause segfaults. Use accum for safety."
      , mkFunc
          "Data.Vector.Generic.Mutable"
          "unsafeUpdate"
          "Unsafe: no bounds checking, may cause segfaults. Use update for safety."
      ]

let unsafePrimitiveMutableExtra
    : List Types.Function
    = [ mkFunc
          "Data.Vector.Primitive.Mutable"
          "unsafeCast"
          "Unsafe: type cast without memory safety guarantees. Ensure correct memory layout."
      , mkFunc
          "Data.Vector.Primitive.Mutable"
          "unsafeCoerceMVector"
          "Unsafe: coerces vector type without safety checks."
      ]

let unsafeStorableMutableExtra
    : List Types.Function
    = [ mkFunc
          "Data.Vector.Storable.Mutable"
          "unsafeCast"
          "Unsafe: type cast without memory safety guarantees. Ensure correct memory layout."
      , mkFunc
          "Data.Vector.Storable.Mutable"
          "unsafeCoerceMVector"
          "Unsafe: coerces vector type without safety checks."
      , mkFunc
          "Data.Vector.Storable.Mutable"
          "unsafeFromForeignPtr"
          "Unsafe: creates vector from raw pointer without validation."
      , mkFunc
          "Data.Vector.Storable.Mutable"
          "unsafeFromForeignPtr0"
          "Unsafe: creates vector from raw pointer without validation."
      , mkFunc
          "Data.Vector.Storable.Mutable"
          "unsafeToForeignPtr"
          "Unsafe: extracts raw pointer, vector may not be used safely after."
      , mkFunc
          "Data.Vector.Storable.Mutable"
          "unsafeToForeignPtr0"
          "Unsafe: extracts raw pointer, vector may not be used safely after."
      , mkFunc
          "Data.Vector.Storable.Mutable"
          "unsafeWith"
          "Unsafe: passes raw pointer to IO action without safety guarantees."
      ]

let immutablePartialFuncs
    : List Types.Function
    = Builder.Prelude.List.concat
        Types.Function
        ( Builder.Prelude.List.map
            Text
            (List Types.Function)
            partialImmutable
            immutableModules
        )

let immutableUnsafeFuncs
    : List Types.Function
    = Builder.Prelude.List.concat
        Types.Function
        ( Builder.Prelude.List.map
            Text
            (List Types.Function)
            unsafeImmutable
            immutableModules
        )

let mutablePartialFuncs
    : List Types.Function
    = Builder.Prelude.List.concat
        Types.Function
        ( Builder.Prelude.List.map
            Text
            (List Types.Function)
            partialMutable
            mutableModules
        )

let mutableUnsafeFuncs
    : List Types.Function
    = Builder.Prelude.List.concat
        Types.Function
        ( Builder.Prelude.List.map
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
