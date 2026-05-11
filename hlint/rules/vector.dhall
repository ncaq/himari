let Prelude =
      https://prelude.dhall-lang.org/v23.1.0/package.dhall
        sha256:931cbfae9d746c4611b07633ab1e547637ab4ba138b16bf65ef1b9ad66a60b7f

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

let indexBangMessage =
      "Partial: throws on out-of-bounds. Use (!?) for safe indexing."

let indexBang =
      \(module : Text) -> Builder.restrictInModule module "!" indexBangMessage

let headMessage =
      "Partial: throws on empty vector. Use uncons or (!?) 0 instead."

let head =
      \(module : Text) -> Builder.restrictInModule module "head" headMessage

let lastMessage =
      "Partial: throws on empty vector. Use unsnoc or check null first."

let last =
      \(module : Text) -> Builder.restrictInModule module "last" lastMessage

let indexMMessage =
          "Partial: throws on out-of-bounds regardless of Monad "
      ++  "(M is for evaluation control, not error handling). "
      ++  "Use (!?) for safe indexing."

let indexM =
      \(module : Text) -> Builder.restrictInModule module "indexM" indexMMessage

let headMMessage =
          "Partial: throws on empty vector regardless of Monad "
      ++  "(M is for evaluation control, not error handling). "
      ++  "Use uncons or check null first."

let headM =
      \(module : Text) -> Builder.restrictInModule module "headM" headMMessage

let lastMMessage =
          "Partial: throws on empty vector regardless of Monad "
      ++  "(M is for evaluation control, not error handling). "
      ++  "Use unsnoc or check null first."

let lastM =
      \(module : Text) -> Builder.restrictInModule module "lastM" lastMMessage

let initMessage = "Partial: throws on empty vector. Use unsnoc for safe init."

let init =
      \(module : Text) -> Builder.restrictInModule module "init" initMessage

let tailMessage = "Partial: throws on empty vector. Use uncons for safe tail."

let tail =
      \(module : Text) -> Builder.restrictInModule module "tail" tailMessage

let batchUpdateMessage =
          "Partial: throws on out-of-bounds indices. "
      ++  "Validate indices against length or use modify."

let updateBang =
      \(module : Text) ->
        Builder.restrictInModule module "//" batchUpdateMessage

let update =
      \(module : Text) ->
        Builder.restrictInModule module "update" batchUpdateMessage

let updateUnderscore =
      \(module : Text) ->
        Builder.restrictInModule module "update_" batchUpdateMessage

let accum =
      \(module : Text) ->
        Builder.restrictInModule module "accum" batchUpdateMessage

let accumulate =
      \(module : Text) ->
        Builder.restrictInModule module "accumulate" batchUpdateMessage

let accumulateUnderscore =
      \(module : Text) ->
        Builder.restrictInModule module "accumulate_" batchUpdateMessage

let backpermute =
      \(module : Text) ->
        Builder.restrictInModule module "backpermute" batchUpdateMessage

let foldl1Message =
      "Partial: throws on empty vector. Use foldl with explicit initial value."

let foldl1 =
      \(module : Text) -> Builder.restrictInModule module "foldl1" foldl1Message

let foldl1StrictMessage =
      "Partial: throws on empty vector. Use foldl' with explicit initial value."

let foldl1Strict =
      \(module : Text) ->
        Builder.restrictInModule module "foldl1'" foldl1StrictMessage

let foldr1Message =
      "Partial: throws on empty vector. Use foldr with explicit initial value."

let foldr1 =
      \(module : Text) -> Builder.restrictInModule module "foldr1" foldr1Message

let foldr1StrictMessage =
      "Partial: throws on empty vector. Use foldr' with explicit initial value."

let foldr1Strict =
      \(module : Text) ->
        Builder.restrictInModule module "foldr1'" foldr1StrictMessage

let foldMaxMinMessage =
      "Partial: throws on empty vector. Use fold with explicit initial value."

let maximum =
      \(module : Text) ->
        Builder.restrictInModule module "maximum" foldMaxMinMessage

let maximumBy =
      \(module : Text) ->
        Builder.restrictInModule module "maximumBy" foldMaxMinMessage

let minimum =
      \(module : Text) ->
        Builder.restrictInModule module "minimum" foldMaxMinMessage

let minimumBy =
      \(module : Text) ->
        Builder.restrictInModule module "minimumBy" foldMaxMinMessage

let indexFoldMessage =
      "Partial: throws on empty vector. Use indexed fold with Maybe result."

let minIndex =
      \(module : Text) ->
        Builder.restrictInModule module "minIndex" indexFoldMessage

let minIndexBy =
      \(module : Text) ->
        Builder.restrictInModule module "minIndexBy" indexFoldMessage

let maxIndex =
      \(module : Text) ->
        Builder.restrictInModule module "maxIndex" indexFoldMessage

let maxIndexBy =
      \(module : Text) ->
        Builder.restrictInModule module "maxIndexBy" indexFoldMessage

let fold1MMessage =
      "Partial: throws on empty vector. Use foldM with explicit initial value."

let fold1M =
      \(module : Text) -> Builder.restrictInModule module "fold1M" fold1MMessage

let fold1MStrictMessage =
      "Partial: throws on empty vector. Use foldM' with explicit initial value."

let fold1MStrict =
      \(module : Text) ->
        Builder.restrictInModule module "fold1M'" fold1MStrictMessage

let fold1MUnderscoreMessage =
      "Partial: throws on empty vector. Use foldM_ with explicit initial value."

let fold1MUnderscore =
      \(module : Text) ->
        Builder.restrictInModule module "fold1M_" fold1MUnderscoreMessage

let fold1MStrictUnderscoreMessage =
      "Partial: throws on empty vector. Use foldM'_ with explicit initial value."

let fold1MStrictUnderscore =
      \(module : Text) ->
        Builder.restrictInModule module "fold1M'_" fold1MStrictUnderscoreMessage

let scanl1Message =
      "Partial: throws on empty vector. Use scanl with explicit initial value."

let scanl1 =
      \(module : Text) -> Builder.restrictInModule module "scanl1" scanl1Message

let scanl1StrictMessage =
      "Partial: throws on empty vector. Use scanl' with explicit initial value."

let scanl1Strict =
      \(module : Text) ->
        Builder.restrictInModule module "scanl1'" scanl1StrictMessage

let scanr1Message =
      "Partial: throws on empty vector. Use scanr with explicit initial value."

let scanr1 =
      \(module : Text) -> Builder.restrictInModule module "scanr1" scanr1Message

let scanr1StrictMessage =
      "Partial: throws on empty vector. Use scanr' with explicit initial value."

let scanr1Strict =
      \(module : Text) ->
        Builder.restrictInModule module "scanr1'" scanr1StrictMessage

let partialImmutable
    : Text -> List Types.Function
    = \(module : Text) ->
        [ indexBang module
        , head module
        , last module
        , indexM module
        , headM module
        , lastM module
        , init module
        , tail module
        , updateBang module
        , update module
        , updateUnderscore module
        , accum module
        , accumulate module
        , accumulateUnderscore module
        , backpermute module
        , foldl1 module
        , foldl1Strict module
        , foldr1 module
        , foldr1Strict module
        , maximum module
        , maximumBy module
        , minimum module
        , minimumBy module
        , minIndex module
        , minIndexBy module
        , maxIndex module
        , maxIndexBy module
        , fold1M module
        , fold1MStrict module
        , fold1MUnderscore module
        , fold1MStrictUnderscore module
        , scanl1 module
        , scanl1Strict module
        , scanr1 module
        , scanr1Strict module
        ]

let unsafeIndexMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use (!) or (!?) instead."

let unsafeIndex =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeIndex" unsafeIndexMessage

let unsafeHeadMessage =
      "Unsafe: no empty check, may cause segfaults. Use uncons or (!?) 0 instead."

let unsafeHead =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeHead" unsafeHeadMessage

let unsafeLastMessage =
      "Unsafe: no empty check, may cause segfaults. Use unsnoc or check null first."

let unsafeLast =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeLast" unsafeLastMessage

let unsafeIndexMMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use (!?) instead."

let unsafeIndexM =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeIndexM" unsafeIndexMMessage

let unsafeHeadM =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeHeadM" unsafeHeadMessage

let unsafeLastM =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeLastM" unsafeLastMessage

let unsafeSliceMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use slice instead."

let unsafeSlice =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeSlice" unsafeSliceMessage

let unsafeInitMessage =
      "Unsafe: no empty check, may cause segfaults. Use unsnoc instead."

let unsafeInit =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeInit" unsafeInitMessage

let unsafeTailMessage =
      "Unsafe: no empty check, may cause segfaults. Use uncons instead."

let unsafeTail =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeTail" unsafeTailMessage

let unsafeTakeMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use take instead."

let unsafeTake =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeTake" unsafeTakeMessage

let unsafeDropMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use drop instead."

let unsafeDrop =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeDrop" unsafeDropMessage

let unsafeUpdBangMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use (//) instead."

let unsafeUpdBang =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeUpd" unsafeUpdBangMessage

let unsafeUpdateMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use update instead."

let unsafeUpdate =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeUpdate" unsafeUpdateMessage

let unsafeUpdateUnderscoreMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use update_ instead."

let unsafeUpdateUnderscore =
      \(module : Text) ->
        Builder.restrictInModule
          module
          "unsafeUpdate_"
          unsafeUpdateUnderscoreMessage

let unsafeAccumMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use accum instead."

let unsafeAccum =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeAccum" unsafeAccumMessage

let unsafeAccumulateMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use accumulate instead."

let unsafeAccumulate =
      \(module : Text) ->
        Builder.restrictInModule
          module
          "unsafeAccumulate"
          unsafeAccumulateMessage

let unsafeAccumulateUnderscoreMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use accumulate_ instead."

let unsafeAccumulateUnderscore =
      \(module : Text) ->
        Builder.restrictInModule
          module
          "unsafeAccumulate_"
          unsafeAccumulateUnderscoreMessage

let unsafeBackpermuteMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use backpermute instead."

let unsafeBackpermute =
      \(module : Text) ->
        Builder.restrictInModule
          module
          "unsafeBackpermute"
          unsafeBackpermuteMessage

let unsafeFreezeMessage =
      "Unsafe: the mutable vector may not be used after this. Use freeze for safety."

let unsafeFreeze =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeFreeze" unsafeFreezeMessage

let unsafeThawMessage =
      "Unsafe: the immutable vector may not be used after this. Use thaw for safety."

let unsafeThaw =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeThaw" unsafeThawMessage

let unsafeCopyMessage = "Unsafe: no length checking. Use copy for safety."

let unsafeCopy =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeCopy" unsafeCopyMessage

let unsafeImmutable
    : Text -> List Types.Function
    = \(module : Text) ->
        [ unsafeIndex module
        , unsafeHead module
        , unsafeLast module
        , unsafeIndexM module
        , unsafeHeadM module
        , unsafeLastM module
        , unsafeSlice module
        , unsafeInit module
        , unsafeTail module
        , unsafeTake module
        , unsafeDrop module
        , unsafeUpdBang module
        , unsafeUpdate module
        , unsafeUpdateUnderscore module
        , unsafeAccum module
        , unsafeAccumulate module
        , unsafeAccumulateUnderscore module
        , unsafeBackpermute module
        , unsafeFreeze module
        , unsafeThaw module
        , unsafeCopy module
        ]

let mutInitMessage =
      "Partial: throws on empty vector. Use unsafeInit only if you've verified non-empty."

let mutInit =
      \(module : Text) -> Builder.restrictInModule module "init" mutInitMessage

let mutTailMessage =
      "Partial: throws on empty vector. Use unsafeTail only if you've verified non-empty."

let mutTail =
      \(module : Text) -> Builder.restrictInModule module "tail" mutTailMessage

let mutUnsafeInitMessage =
      "Unsafe: no empty check, may cause segfaults. Verify non-empty first."

let mutUnsafeInit =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeInit" mutUnsafeInitMessage

let mutUnsafeTail =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeTail" mutUnsafeInitMessage

let unsafeReadMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use read instead."

let unsafeRead =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeRead" unsafeReadMessage

let unsafeWriteMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use write instead."

let unsafeWrite =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeWrite" unsafeWriteMessage

let unsafeModifyMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use modify instead."

let unsafeModify =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeModify" unsafeModifyMessage

let unsafeModifyMMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use modifyM instead."

let unsafeModifyM =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeModifyM" unsafeModifyMMessage

let unsafeSwapMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use swap instead."

let unsafeSwap =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeSwap" unsafeSwapMessage

let unsafeExchangeMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use exchange instead."

let unsafeExchange =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeExchange" unsafeExchangeMessage

let mutUnsafeCopyMessage =
      "Unsafe: no length/overlap checking. Use copy for safety."

let mutUnsafeCopy =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeCopy" mutUnsafeCopyMessage

let unsafeMoveMessage = "Unsafe: no length checking. Use move for safety."

let unsafeMove =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeMove" unsafeMoveMessage

let unsafeGrowMessage = "Unsafe: no non-negative check. Use grow for safety."

let unsafeGrow =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeGrow" unsafeGrowMessage

let unsafeNewMessage =
      "Unsafe: elements are uninitialized and may cause exceptions. Use new or replicate instead."

let unsafeNew =
      \(module : Text) ->
        Builder.restrictInModule module "unsafeNew" unsafeNewMessage

let unsafeMutable
    : Text -> List Types.Function
    = \(module : Text) ->
        [ unsafeSlice module
        , mutUnsafeInit module
        , mutUnsafeTail module
        , unsafeTake module
        , unsafeDrop module
        , unsafeRead module
        , unsafeWrite module
        , unsafeModify module
        , unsafeModifyM module
        , unsafeSwap module
        , unsafeExchange module
        , mutUnsafeCopy module
        , unsafeMove module
        , unsafeGrow module
        , unsafeNew module
        ]

let genericUnsafeGrowFrontMessage =
      "Unsafe: no non-negative check. Use growFront for safety."

let genericUnsafeGrowFront =
      Builder.restrictInModule
        "Data.Vector.Generic.Mutable"
        "unsafeGrowFront"
        genericUnsafeGrowFrontMessage

let genericUnsafeAccumMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use accum for safety."

let genericUnsafeAccum =
      Builder.restrictInModule
        "Data.Vector.Generic.Mutable"
        "unsafeAccum"
        genericUnsafeAccumMessage

let genericUnsafeUpdateMessage =
      "Unsafe: no bounds checking, may cause segfaults. Use update for safety."

let genericUnsafeUpdate =
      Builder.restrictInModule
        "Data.Vector.Generic.Mutable"
        "unsafeUpdate"
        genericUnsafeUpdateMessage

let unsafeGenericMutableExtra
    : List Types.Function
    = [ genericUnsafeGrowFront, genericUnsafeAccum, genericUnsafeUpdate ]

let primitiveUnsafeCastMessage =
      "Unsafe: type cast without memory safety guarantees. Ensure correct memory layout."

let primitiveUnsafeCast =
      Builder.restrictInModule
        "Data.Vector.Primitive.Mutable"
        "unsafeCast"
        primitiveUnsafeCastMessage

let primitiveUnsafeCoerceMVectorMessage =
      "Unsafe: coerces vector type without safety checks."

let primitiveUnsafeCoerceMVector =
      Builder.restrictInModule
        "Data.Vector.Primitive.Mutable"
        "unsafeCoerceMVector"
        primitiveUnsafeCoerceMVectorMessage

let storableUnsafeCastMessage =
      "Unsafe: type cast without memory safety guarantees. Ensure correct memory layout."

let storableUnsafeCast =
      Builder.restrictInModule
        "Data.Vector.Storable.Mutable"
        "unsafeCast"
        storableUnsafeCastMessage

let storableUnsafeCoerceMVectorMessage =
      "Unsafe: coerces vector type without safety checks."

let storableUnsafeCoerceMVector =
      Builder.restrictInModule
        "Data.Vector.Storable.Mutable"
        "unsafeCoerceMVector"
        storableUnsafeCoerceMVectorMessage

let unsafePrimitiveMutableExtra
    : List Types.Function
    = [ primitiveUnsafeCast, primitiveUnsafeCoerceMVector ]

let storableUnsafeFromForeignPtrMessage =
      "Unsafe: creates vector from raw pointer without validation."

let storableUnsafeFromForeignPtr =
      Builder.restrictInModule
        "Data.Vector.Storable.Mutable"
        "unsafeFromForeignPtr"
        storableUnsafeFromForeignPtrMessage

let storableUnsafeFromForeignPtr0 =
      Builder.restrictInModule
        "Data.Vector.Storable.Mutable"
        "unsafeFromForeignPtr0"
        storableUnsafeFromForeignPtrMessage

let storableUnsafeToForeignPtrMessage =
      "Unsafe: extracts raw pointer, vector may not be used safely after."

let storableUnsafeToForeignPtr =
      Builder.restrictInModule
        "Data.Vector.Storable.Mutable"
        "unsafeToForeignPtr"
        storableUnsafeToForeignPtrMessage

let storableUnsafeToForeignPtr0 =
      Builder.restrictInModule
        "Data.Vector.Storable.Mutable"
        "unsafeToForeignPtr0"
        storableUnsafeToForeignPtrMessage

let storableUnsafeWithMessage =
      "Unsafe: passes raw pointer to IO action without safety guarantees."

let storableUnsafeWith =
      Builder.restrictInModule
        "Data.Vector.Storable.Mutable"
        "unsafeWith"
        storableUnsafeWithMessage

let unsafeStorableMutableExtra
    : List Types.Function
    = [ storableUnsafeCast
      , storableUnsafeCoerceMVector
      , storableUnsafeFromForeignPtr
      , storableUnsafeFromForeignPtr0
      , storableUnsafeToForeignPtr
      , storableUnsafeToForeignPtr0
      , storableUnsafeWith
      ]

let partialMutable
    : Text -> List Types.Function
    = \(module : Text) -> [ mutInit module, mutTail module ]

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
