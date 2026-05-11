let Types = ../Types.dhall

let Builder = ../Builder.dhall

let succMessage =
      "Partial: throws on maxBound. Use succMay, succDef, or succSafe from Safe instead."

let succ = Builder.restrictFunction "succ" succMessage

let predMessage =
      "Partial: throws on minBound. Use predMay, predDef, or predSafe from Safe instead."

let pred = Builder.restrictFunction "pred" predMessage

let toEnumMessage =
      "Partial: throws on out-of-bounds. Use toEnumMay, toEnumDef, or toEnumSafe from Safe instead."

let toEnum = Builder.restrictFunction "toEnum" toEnumMessage

let listHeadMessage =
      "Partial: throws on empty list. Use headMay or headDef from Safe instead."

let listHead = Builder.restrictInModule "Data.List" "head" listHeadMessage

let listTailMessage =
      "Partial: throws on empty list. Use tailMay, tailDef, or tailSafe from Safe instead."

let listTail = Builder.restrictInModule "Data.List" "tail" listTailMessage

let listInitMessage =
      "Partial: throws on empty list. Use initMay, initDef, or initSafe from Safe instead."

let listInit = Builder.restrictInModule "Data.List" "init" listInitMessage

let listLastMessage =
      "Partial: throws on empty list. Use lastMay or lastDef from Safe instead."

let listLast = Builder.restrictInModule "Data.List" "last" listLastMessage

let listIndexMessage =
      "Partial: throws on out-of-bounds. Use atMay or atDef from Safe instead."

let listIndex = Builder.restrictFunction "Data.List.!!" listIndexMessage

let listCycleMessage =
      "Partial: throws on empty list. Use cycleMay or cycleDef from Safe instead."

let listCycle = Builder.restrictInModule "Data.List" "cycle" listCycleMessage

let listScanl1Message =
      "Partial: throws on empty list. Use scanl1May or scanl1Def from Safe instead."

let listScanl1 = Builder.restrictInModule "Data.List" "scanl1" listScanl1Message

let listScanr1Message =
      "Partial: throws on empty list. Use scanr1May or scanr1Def from Safe instead."

let listScanr1 = Builder.restrictInModule "Data.List" "scanr1" listScanr1Message

let listFoldl1Message =
      "Partial: throws on empty list. Use foldl1May from Safe instead."

let listFoldl1 = Builder.restrictInModule "Data.List" "foldl1" listFoldl1Message

let listFoldl1StrictMessage =
      "Partial: throws on empty list. Use foldl1May' from Safe instead."

let listFoldl1Strict =
      Builder.restrictInModule "Data.List" "foldl1'" listFoldl1StrictMessage

let listFoldr1Message =
      "Partial: throws on empty list. Use foldr1May from Safe instead."

let listFoldr1 = Builder.restrictInModule "Data.List" "foldr1" listFoldr1Message

let listMaximumMessage =
      "Partial: throws on empty list. Use maximumMay or maximumBound from Safe instead."

let listMaximum =
      Builder.restrictInModule "Data.List" "maximum" listMaximumMessage

let listMinimumMessage =
      "Partial: throws on empty list. Use minimumMay or minimumBound from Safe instead."

let listMinimum =
      Builder.restrictInModule "Data.List" "minimum" listMinimumMessage

let listMaximumByMessage =
      "Partial: throws on empty list. Use maximumByMay or maximumBoundBy from Safe instead."

let listMaximumBy =
      Builder.restrictInModule "Data.List" "maximumBy" listMaximumByMessage

let listMinimumByMessage =
      "Partial: throws on empty list. Use minimumByMay or minimumBoundBy from Safe instead."

let listMinimumBy =
      Builder.restrictInModule "Data.List" "minimumBy" listMinimumByMessage

let fromJustMessage =
      "Partial: throws on Nothing. Use fromMaybe or pattern match instead."

let fromJust = Builder.restrictInModule "Data.Maybe" "fromJust" fromJustMessage

let readMessage =
      "Partial: throws on parse failure. Use readMay or readDef from Safe instead."

let read = Builder.restrictFunction "read" readMessage

let foldableFoldl1Message =
      "Partial: throws on empty structure. Use foldl1May from Safe.Foldable instead."

let foldableFoldl1 =
      Builder.restrictInModule "Data.Foldable" "foldl1" foldableFoldl1Message

let foldableFoldr1Message =
      "Partial: throws on empty structure. Use foldr1May from Safe.Foldable instead."

let foldableFoldr1 =
      Builder.restrictInModule "Data.Foldable" "foldr1" foldableFoldr1Message

let foldableMaximumMessage =
          "Partial: throws on empty structure. "
      ++  "Use maximumMay or maximumBound from Safe.Foldable instead."

let foldableMaximum =
      Builder.restrictInModule "Data.Foldable" "maximum" foldableMaximumMessage

let foldableMinimumMessage =
          "Partial: throws on empty structure. "
      ++  "Use minimumMay or minimumBound from Safe.Foldable instead."

let foldableMinimum =
      Builder.restrictInModule "Data.Foldable" "minimum" foldableMinimumMessage

let foldableMaximumByMessage =
          "Partial: throws on empty structure. "
      ++  "Use maximumByMay or maximumBoundBy from Safe.Foldable instead."

let foldableMaximumBy =
      Builder.restrictInModule
        "Data.Foldable"
        "maximumBy"
        foldableMaximumByMessage

let foldableMinimumByMessage =
          "Partial: throws on empty structure. "
      ++  "Use minimumByMay or minimumBoundBy from Safe.Foldable instead."

let foldableMinimumBy =
      Builder.restrictInModule
        "Data.Foldable"
        "minimumBy"
        foldableMinimumByMessage

let bifoldl1Message =
      "Partial: throws on empty structure. Use bifoldl with a default value instead."

let bifoldl1 =
      Builder.restrictInModule "Data.Bifoldable" "bifoldl1" bifoldl1Message

let bifoldr1Message =
      "Partial: throws on empty structure. Use bifoldr with a default value instead."

let bifoldr1 =
      Builder.restrictInModule "Data.Bifoldable" "bifoldr1" bifoldr1Message

let bimaximumMessage =
      "Partial: throws on empty structure. Use bifoldr with explicit initial value."

let bimaximum =
      Builder.restrictInModule "Data.Bifoldable" "bimaximum" bimaximumMessage

let biminimumMessage =
      "Partial: throws on empty structure. Use bifoldr with explicit initial value."

let biminimum =
      Builder.restrictInModule "Data.Bifoldable" "biminimum" biminimumMessage

let bimaximumByMessage =
      "Partial: throws on empty structure. Use bifoldr with explicit initial value."

let bimaximumBy =
      Builder.restrictInModule
        "Data.Bifoldable"
        "bimaximumBy"
        bimaximumByMessage

let biminimumByMessage =
      "Partial: throws on empty structure. Use bifoldr with explicit initial value."

let biminimumBy =
      Builder.restrictInModule
        "Data.Bifoldable"
        "biminimumBy"
        biminimumByMessage

let neIndexMessage =
      "Partial: throws on out-of-bounds. Use atMay or atDef from Safe with toList instead."

let neIndex = Builder.restrictFunction "Data.List.NonEmpty.!!" neIndexMessage

let neFromListMessage = "Partial: throws on empty list. Use nonEmpty instead."

let neFromList =
      Builder.restrictInModule "Data.List.NonEmpty" "fromList" neFromListMessage

let ixIndexMessage =
      "Partial: throws on out-of-range. Use indexMay or indexDef from Safe instead."

let ixIndex = Builder.restrictInModule "Data.Ix" "index" ixIndexMessage

let safeAbortMessage = "Partial: synonym for error. Use throwM or Left instead."

let safeAbort = Builder.restrictInModule "Safe" "abort" safeAbortMessage

let safeAtMessage =
      "Partial: throws on out-of-bounds. Use atMay or atDef instead."

let safeAt = Builder.restrictInModule "Safe" "at" safeAtMessage

let safeHeadErrMessage =
      "Partial: throws on empty list. Use headMay or headDef instead."

let safeHeadErr = Builder.restrictInModule "Safe" "headErr" safeHeadErrMessage

let safeTailErrMessage =
      "Partial: throws on empty list. Use tailMay or tailDef instead."

let safeTailErr = Builder.restrictInModule "Safe" "tailErr" safeTailErrMessage

let safeLookupJustMessage =
      "Partial: throws on missing key. Use lookup or lookupJustDef instead."

let safeLookupJust =
      Builder.restrictInModule "Safe" "lookupJust" safeLookupJustMessage

let safeFindJustMessage =
      "Partial: throws when not found. Use find or findJustDef instead."

let safeFindJust =
      Builder.restrictInModule "Safe" "findJust" safeFindJustMessage

let safeElemIndexJustMessage =
      "Partial: throws when not found. Use elemIndex or elemIndexJustDef instead."

let safeElemIndexJust =
      Builder.restrictInModule "Safe" "elemIndexJust" safeElemIndexJustMessage

let safeFindIndexJustMessage =
      "Partial: throws when not found. Use findIndex or findIndexJustDef instead."

let safeFindIndexJust =
      Builder.restrictInModule "Safe" "findIndexJust" safeFindIndexJustMessage

let safeTailNoteMessage =
      "Partial: throws on empty list. Use tailMay or tailDef instead."

let safeTailNote =
      Builder.restrictInModule "Safe" "tailNote" safeTailNoteMessage

let safeInitNoteMessage =
      "Partial: throws on empty list. Use initMay or initDef instead."

let safeInitNote =
      Builder.restrictInModule "Safe" "initNote" safeInitNoteMessage

let safeHeadNoteMessage =
      "Partial: throws on empty list. Use headMay or headDef instead."

let safeHeadNote =
      Builder.restrictInModule "Safe" "headNote" safeHeadNoteMessage

let safeLastNoteMessage =
      "Partial: throws on empty list. Use lastMay or lastDef instead."

let safeLastNote =
      Builder.restrictInModule "Safe" "lastNote" safeLastNoteMessage

let safeMinimumNoteMessage =
      "Partial: throws on empty list. Use minimumMay or minimumBound instead."

let safeMinimumNote =
      Builder.restrictInModule "Safe" "minimumNote" safeMinimumNoteMessage

let safeMaximumNoteMessage =
      "Partial: throws on empty list. Use maximumMay or maximumBound instead."

let safeMaximumNote =
      Builder.restrictInModule "Safe" "maximumNote" safeMaximumNoteMessage

let safeMinimumByNoteMessage =
      "Partial: throws on empty list. Use minimumByMay or minimumBoundBy instead."

let safeMinimumByNote =
      Builder.restrictInModule "Safe" "minimumByNote" safeMinimumByNoteMessage

let safeMaximumByNoteMessage =
      "Partial: throws on empty list. Use maximumByMay or maximumBoundBy instead."

let safeMaximumByNote =
      Builder.restrictInModule "Safe" "maximumByNote" safeMaximumByNoteMessage

let safeFoldr1NoteMessage =
      "Partial: throws on empty list. Use foldr1May instead."

let safeFoldr1Note =
      Builder.restrictInModule "Safe" "foldr1Note" safeFoldr1NoteMessage

let safeFoldl1NoteMessage =
      "Partial: throws on empty list. Use foldl1May instead."

let safeFoldl1Note =
      Builder.restrictInModule "Safe" "foldl1Note" safeFoldl1NoteMessage

let safeFoldl1NoteStrictMessage =
      "Partial: throws on empty list. Use foldl1May' instead."

let safeFoldl1NoteStrict =
      Builder.restrictInModule "Safe" "foldl1Note'" safeFoldl1NoteStrictMessage

let safeScanr1NoteMessage =
      "Partial: throws on empty list. Use scanr1May or scanr1Def instead."

let safeScanr1Note =
      Builder.restrictInModule "Safe" "scanr1Note" safeScanr1NoteMessage

let safeScanl1NoteMessage =
      "Partial: throws on empty list. Use scanl1May or scanl1Def instead."

let safeScanl1Note =
      Builder.restrictInModule "Safe" "scanl1Note" safeScanl1NoteMessage

let safeCycleNoteMessage =
      "Partial: throws on empty list. Use cycleMay or cycleDef instead."

let safeCycleNote =
      Builder.restrictInModule "Safe" "cycleNote" safeCycleNoteMessage

let safeFromJustNoteMessage =
      "Partial: throws on Nothing. Use fromMaybe instead."

let safeFromJustNote =
      Builder.restrictInModule "Safe" "fromJustNote" safeFromJustNoteMessage

let safeAssertNoteMessage =
      "Partial: throws on False. Use guard or when instead."

let safeAssertNote =
      Builder.restrictInModule "Safe" "assertNote" safeAssertNoteMessage

let safeAtNoteMessage =
      "Partial: throws on out-of-bounds. Use atMay or atDef instead."

let safeAtNote = Builder.restrictInModule "Safe" "atNote" safeAtNoteMessage

let safeReadNoteMessage =
      "Partial: throws on parse failure. Use readMay or readDef instead."

let safeReadNote =
      Builder.restrictInModule "Safe" "readNote" safeReadNoteMessage

let safeLookupJustNoteMessage =
      "Partial: throws on missing key. Use lookup or lookupJustDef instead."

let safeLookupJustNote =
      Builder.restrictInModule "Safe" "lookupJustNote" safeLookupJustNoteMessage

let safeFindJustNoteMessage =
      "Partial: throws when not found. Use find or findJustDef instead."

let safeFindJustNote =
      Builder.restrictInModule "Safe" "findJustNote" safeFindJustNoteMessage

let safeElemIndexJustNoteMessage =
      "Partial: throws when not found. Use elemIndex or elemIndexJustDef instead."

let safeElemIndexJustNote =
      Builder.restrictInModule
        "Safe"
        "elemIndexJustNote"
        safeElemIndexJustNoteMessage

let safeFindIndexJustNoteMessage =
      "Partial: throws when not found. Use findIndex or findIndexJustDef instead."

let safeFindIndexJustNote =
      Builder.restrictInModule
        "Safe"
        "findIndexJustNote"
        safeFindIndexJustNoteMessage

let safeToEnumNoteMessage =
      "Partial: throws on out-of-bounds. Use toEnumMay or toEnumDef instead."

let safeToEnumNote =
      Builder.restrictInModule "Safe" "toEnumNote" safeToEnumNoteMessage

let safeSuccNoteMessage =
      "Partial: throws on maxBound. Use succMay or succDef instead."

let safeSuccNote =
      Builder.restrictInModule "Safe" "succNote" safeSuccNoteMessage

let safePredNoteMessage =
      "Partial: throws on minBound. Use predMay or predDef instead."

let safePredNote =
      Builder.restrictInModule "Safe" "predNote" safePredNoteMessage

let safeIndexNoteMessage =
      "Partial: throws on out-of-range. Use indexMay or indexDef instead."

let safeIndexNote =
      Builder.restrictInModule "Safe" "indexNote" safeIndexNoteMessage

let safeExactTakeMessage =
      "Partial: throws on insufficient elements. Use takeExactMay or takeExactDef instead."

let safeExactTake =
      Builder.restrictInModule "Safe.Exact" "takeExact" safeExactTakeMessage

let safeExactDropMessage =
      "Partial: throws on insufficient elements. Use dropExactMay or dropExactDef instead."

let safeExactDrop =
      Builder.restrictInModule "Safe.Exact" "dropExact" safeExactDropMessage

let safeExactSplitAtMessage =
      "Partial: throws on insufficient elements. Use splitAtExactMay or splitAtExactDef instead."

let safeExactSplitAt =
      Builder.restrictInModule
        "Safe.Exact"
        "splitAtExact"
        safeExactSplitAtMessage

let safeExactZipMessage =
      "Partial: throws on length mismatch. Use zipExactMay or zipExactDef instead."

let safeExactZip =
      Builder.restrictInModule "Safe.Exact" "zipExact" safeExactZipMessage

let safeExactZipWithMessage =
      "Partial: throws on length mismatch. Use zipWithExactMay or zipWithExactDef instead."

let safeExactZipWith =
      Builder.restrictInModule
        "Safe.Exact"
        "zipWithExact"
        safeExactZipWithMessage

let safeExactZip3Message =
      "Partial: throws on length mismatch. Use zip3ExactMay or zip3ExactDef instead."

let safeExactZip3 =
      Builder.restrictInModule "Safe.Exact" "zip3Exact" safeExactZip3Message

let safeExactZipWith3Message =
      "Partial: throws on length mismatch. Use zipWith3ExactMay or zipWith3ExactDef instead."

let safeExactZipWith3 =
      Builder.restrictInModule
        "Safe.Exact"
        "zipWith3Exact"
        safeExactZipWith3Message

let safeExactTakeNote =
      Builder.restrictInModule "Safe.Exact" "takeExactNote" safeExactTakeMessage

let safeExactDropNote =
      Builder.restrictInModule "Safe.Exact" "dropExactNote" safeExactDropMessage

let safeExactSplitAtNote =
      Builder.restrictInModule
        "Safe.Exact"
        "splitAtExactNote"
        safeExactSplitAtMessage

let safeExactZipNote =
      Builder.restrictInModule "Safe.Exact" "zipExactNote" safeExactZipMessage

let safeExactZipWithNote =
      Builder.restrictInModule
        "Safe.Exact"
        "zipWithExactNote"
        safeExactZipWithMessage

let safeExactZip3Note =
      Builder.restrictInModule "Safe.Exact" "zip3ExactNote" safeExactZip3Message

let safeExactZipWith3Note =
      Builder.restrictInModule
        "Safe.Exact"
        "zipWith3ExactNote"
        safeExactZipWith3Message

let safeFoldableFoldl1NoteMessage =
      "Partial: throws on empty structure. Use foldl1May instead."

let safeFoldableFoldl1Note =
      Builder.restrictInModule
        "Safe.Foldable"
        "foldl1Note"
        safeFoldableFoldl1NoteMessage

let safeFoldableFoldr1NoteMessage =
      "Partial: throws on empty structure. Use foldr1May instead."

let safeFoldableFoldr1Note =
      Builder.restrictInModule
        "Safe.Foldable"
        "foldr1Note"
        safeFoldableFoldr1NoteMessage

let safeFoldableMinimumNoteMessage =
      "Partial: throws on empty structure. Use minimumMay or minimumBound instead."

let safeFoldableMinimumNote =
      Builder.restrictInModule
        "Safe.Foldable"
        "minimumNote"
        safeFoldableMinimumNoteMessage

let safeFoldableMaximumNoteMessage =
      "Partial: throws on empty structure. Use maximumMay or maximumBound instead."

let safeFoldableMaximumNote =
      Builder.restrictInModule
        "Safe.Foldable"
        "maximumNote"
        safeFoldableMaximumNoteMessage

let safeFoldableMinimumByNoteMessage =
      "Partial: throws on empty structure. Use minimumByMay or minimumBoundBy instead."

let safeFoldableMinimumByNote =
      Builder.restrictInModule
        "Safe.Foldable"
        "minimumByNote"
        safeFoldableMinimumByNoteMessage

let safeFoldableMaximumByNoteMessage =
      "Partial: throws on empty structure. Use maximumByMay or maximumBoundBy instead."

let safeFoldableMaximumByNote =
      Builder.restrictInModule
        "Safe.Foldable"
        "maximumByNote"
        safeFoldableMaximumByNoteMessage

let safeFoldableFindJustMessage =
      "Partial: throws when not found. Use find or findJustDef instead."

let safeFoldableFindJust =
      Builder.restrictInModule
        "Safe.Foldable"
        "findJust"
        safeFoldableFindJustMessage

let safeFoldableFindJustNoteMessage =
      "Partial: throws when not found. Use find or findJustDef instead."

let safeFoldableFindJustNote =
      Builder.restrictInModule
        "Safe.Foldable"
        "findJustNote"
        safeFoldableFindJustNoteMessage

let rules
    : List Types.Rule
    =
      -- Prelude/base partial functions -> Safe alternatives
      [ Builder.functions [ succ, pred, toEnum ]
      , Builder.functions
          [ listHead
          , listTail
          , listInit
          , listLast
          , listIndex
          , listCycle
          , listScanl1
          , listScanr1
          , listFoldl1
          , listFoldl1Strict
          , listFoldr1
          , listMaximum
          , listMinimum
          , listMaximumBy
          , listMinimumBy
          ]
      , Builder.functions [ fromJust ]
      , Builder.functions [ read ]
      , Builder.functions
          [ foldableFoldl1
          , foldableFoldr1
          , foldableMaximum
          , foldableMinimum
          , foldableMaximumBy
          , foldableMinimumBy
          ]
      , Builder.functions
          [ bifoldl1, bifoldr1, bimaximum, biminimum, bimaximumBy, biminimumBy ]
      , Builder.functions [ neIndex, neFromList ]
      , Builder.functions [ ixIndex ]
      , Builder.functions
          [ safeAbort
          , safeAt
          , safeHeadErr
          , safeTailErr
          , safeLookupJust
          , safeFindJust
          , safeElemIndexJust
          , safeFindIndexJust
          ]
      , Builder.functions
          [ safeTailNote
          , safeInitNote
          , safeHeadNote
          , safeLastNote
          , safeMinimumNote
          , safeMaximumNote
          , safeMinimumByNote
          , safeMaximumByNote
          , safeFoldr1Note
          , safeFoldl1Note
          , safeFoldl1NoteStrict
          , safeScanr1Note
          , safeScanl1Note
          , safeCycleNote
          , safeFromJustNote
          , safeAssertNote
          , safeAtNote
          , safeReadNote
          , safeLookupJustNote
          , safeFindJustNote
          , safeElemIndexJustNote
          , safeFindIndexJustNote
          , safeToEnumNote
          , safeSuccNote
          , safePredNote
          , safeIndexNote
          ]
      , Builder.functions
          [ safeExactTake
          , safeExactDrop
          , safeExactSplitAt
          , safeExactZip
          , safeExactZipWith
          , safeExactZip3
          , safeExactZipWith3
          , safeExactTakeNote
          , safeExactDropNote
          , safeExactSplitAtNote
          , safeExactZipNote
          , safeExactZipWithNote
          , safeExactZip3Note
          , safeExactZipWith3Note
          ]
      , Builder.functions
          [ safeFoldableFoldl1Note
          , safeFoldableFoldr1Note
          , safeFoldableMinimumNote
          , safeFoldableMaximumNote
          , safeFoldableMinimumByNote
          , safeFoldableMaximumByNote
          , safeFoldableFindJust
          , safeFoldableFindJustNote
          ]
      ]

in  rules
