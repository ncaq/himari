module HlintReexportSpec (spec) where

import Himari
import HlintRunner
import Test.Syd

spec :: Spec
spec = do
  describe "hlint rules for symbols re-exported through himari" $ do
    describe "import Himari" . withSample "ReexportHimari.hs" $ do
      describe "every restricted function re-exported by Himari should warn" $ do
        forM_ reexportedRestrictedFunctions $ \(declName, function) ->
          itWithOuter (convert function <> " should warn") $ \sample ->
            shouldWarnFunction sample declName function ""

      describe "messages should come from the rule of the original function" $ do
        itWithOuter "head should suggest headMay" $ \sample ->
          shouldWarnFunction sample "useHead" "head" "headMay"

        itWithOuter "tail should suggest tailMay" $ \sample ->
          shouldWarnFunction sample "useTail" "tail" "tailMay"

        itWithOuter "fromJust should suggest fromMaybe" $ \sample ->
          shouldWarnFunction sample "useFromJust" "fromJust" "fromMaybe"

        itWithOuter "bifoldl1 should suggest bifoldl" $ \sample ->
          shouldWarnFunction sample "useBifoldl1" "bifoldl1" "bifoldl with a default value"

        itWithOuter "readFile should warn about lazy IO" $ \sample ->
          shouldWarnFunction sample "useReadFile" "readFile" "Lazy IO"

        itWithOuter "print should warn about the encoding" $ \sample ->
          shouldWarnFunction sample "usePrint" "print" "Encoding depends on LANG"

        itWithOuter "singular should suggest (^?)" $ \sample ->
          shouldWarnFunction sample "useSingular" "singular" "(^?)"

        itWithOuter "stringException should suggest typed exceptions" $ \sample ->
          shouldWarnFunction sample "useStringException" "stringException" "typed exceptions"

      describe "functions of both Data.List and Data.Foldable should have a single message" $ do
        forM_ listAndFoldableFunctions $ \(declName, function) ->
          itWithOuter (convert function <> " should not have concatenated messages") $ \sample ->
            shouldWarnFunctionOnce sample declName function "Partial:"

      describe "total alternatives should NOT warn" $ do
        itWithOuter "headMay should NOT warn" $ \sample ->
          sample `shouldNotWarnFunctionIn` "useHeadMay"

        itWithOuter "fromMaybe should NOT warn" $ \sample ->
          sample `shouldNotWarnFunctionIn` "useFromMaybe"

      describe "UnliftIO versions exported by Himari should NOT warn" $ do
        forM_ unliftioDeclarations $ \declName ->
          itWithOuter (convert declName <> " should NOT warn") $ \sample ->
            sample `shouldNotWarnFunctionIn` declName

    describe "import Himari.Prelude" . withSample "ReexportHimariPrelude.hs" $ do
      itWithOuter "head should warn" $ \sample ->
        shouldWarnFunction sample "useHead" "head" "headMay"

      itWithOuter "foldl1 should warn with a single message" $ \sample ->
        shouldWarnFunctionOnce sample "useFoldl1" "foldl1" "Partial:"

      itWithOuter "bifoldl1 should warn" $ \sample ->
        shouldWarnFunction sample "useBifoldl1" "bifoldl1" "bifoldl with a default value"

      itWithOuter "fromJust should warn" $ \sample ->
        shouldWarnFunction sample "useFromJust" "fromJust" "fromMaybe"

      itWithOuter "readFile should warn" $ \sample ->
        shouldWarnFunction sample "useReadFile" "readFile" "Lazy IO"

      itWithOuter "singular should warn" $ \sample ->
        shouldWarnFunction sample "useSingular" "singular" "(^?)"

      itWithOuter "stringException should warn" $ \sample ->
        shouldWarnFunction sample "useStringException" "stringException" "typed exceptions"

      itWithOuter "headMay should NOT warn" $ \sample ->
        sample `shouldNotWarnFunctionIn` "useHeadMay"

      itWithOuter "catch of UnliftIO should NOT warn" $ \sample ->
        sample `shouldNotWarnFunctionIn` "useCatch"

    describe "import Himari.SafePrelude" . withSample "ReexportSafePrelude.hs" $ do
      itWithOuter "head should warn" $ \sample ->
        shouldWarnFunction sample "useHead" "head" "headMay"

      itWithOuter "foldl1 should warn with a single message" $ \sample ->
        shouldWarnFunctionOnce sample "useFoldl1" "foldl1" "Partial:"

      itWithOuter "bifoldl1 should warn" $ \sample ->
        shouldWarnFunction sample "useBifoldl1" "bifoldl1" "bifoldl with a default value"

      itWithOuter "fromJust should warn" $ \sample ->
        shouldWarnFunction sample "useFromJust" "fromJust" "fromMaybe"

      itWithOuter "readFile should warn" $ \sample ->
        shouldWarnFunction sample "useReadFile" "readFile" "Lazy IO"

      itWithOuter "singular should warn" $ \sample ->
        shouldWarnFunction sample "useSingular" "singular" "(^?)"

      itWithOuter "headMay should NOT warn" $ \sample ->
        sample `shouldNotWarnFunctionIn` "useHeadMay"

    describe "import forms of Himari" . withSample "ReexportImportForms.hs" $ do
      itWithOuter "head qualified with the alias of Himari should warn" $ \sample ->
        shouldWarnFunction sample "useQualifiedHead" "H.head" "headMay"

      itWithOuter "readFile qualified with the alias of Himari should warn" $ \sample ->
        shouldWarnFunction sample "useQualifiedReadFile" "H.readFile" "Lazy IO"

      itWithOuter "tail should warn even though other names are hidden" $ \sample ->
        shouldWarnFunction sample "useTail" "tail" "tailMay"

      itWithOuter "head of Data.List.NonEmpty should NOT warn when hidden from Himari" $ \sample ->
        sample `shouldNotWarnFunctionIn` "useNonEmptyHead"

      itWithOuter "head qualified with Data.List.NonEmpty should NOT warn" $ \sample ->
        sample `shouldNotWarnFunctionIn` "useNonEmptyHeadQualified"

      itWithOuter "definition of a user function named last should NOT warn" $ \sample ->
        sample `shouldNotWarnFunctionIn` "last"

      itWithOuter "use of a user function named last should NOT warn" $ \sample ->
        sample `shouldNotWarnFunctionIn` "useOwnLast"

    describe "explicit import list of Himari" . withSample "ReexportExplicitImport.hs" $ do
      itWithOuter "head should warn" $ \sample ->
        shouldWarnFunction sample "useHead" "head" "headMay"

      itWithOuter "readFile should warn" $ \sample ->
        shouldWarnFunction sample "useReadFile" "readFile" "Lazy IO"

      itWithOuter "headMay should NOT warn" $ \sample ->
        sample `shouldNotWarnFunctionIn` "useHeadMay"

-- | Declarations of the sample paired with the restricted function they use.
-- These are all the functions that have a module qualified rule in @.hlint.yaml@
-- and are re-exported by "Himari" as the very same entity.
reexportedRestrictedFunctions :: [(Text, Text)]
reexportedRestrictedFunctions =
  listAndFoldableFunctions
    <> [ ("useHead", "head")
       , ("useTail", "tail")
       , ("useInit", "init")
       , ("useLast", "last")
       , ("useCycle", "cycle")
       , ("useScanl1", "scanl1")
       , ("useScanr1", "scanr1")
       , ("useBifoldl1", "bifoldl1")
       , ("useBifoldr1", "bifoldr1")
       , ("useBimaximum", "bimaximum")
       , ("useBiminimum", "biminimum")
       , ("useBimaximumBy", "bimaximumBy")
       , ("useBiminimumBy", "biminimumBy")
       , ("useFromJust", "fromJust")
       , ("useGetChar", "getChar")
       , ("useGetLine", "getLine")
       , ("useGetContents", "getContents")
       , ("useInteract", "interact")
       , ("useReadIO", "readIO")
       , ("useReadLn", "readLn")
       , ("usePutChar", "putChar")
       , ("usePutStr", "putStr")
       , ("usePutStrLn", "putStrLn")
       , ("usePrint", "print")
       , ("useReadFile", "readFile")
       , ("useWriteFile", "writeFile")
       , ("useAppendFile", "appendFile")
       , ("useSingular", "singular")
       , ("useUnsafeSingular", "unsafeSingular")
       , ("useUnsafePartsOf", "unsafePartsOf")
       , ("useIunsafePartsOf", "iunsafePartsOf")
       , ("useThrowString", "throwString")
       , ("useStringException", "stringException")
       ]

-- | Functions that both "Data.List" and "Data.Foldable" export as the very same entity.
-- Both modules have a rule for them, so their messages are prone to be concatenated.
listAndFoldableFunctions :: [(Text, Text)]
listAndFoldableFunctions =
  [ ("useFoldl1", "foldl1")
  , ("useFoldr1", "foldr1")
  , ("useMaximum", "maximum")
  , ("useMinimum", "minimum")
  , ("useMaximumBy", "maximumBy")
  , ("useMinimumBy", "minimumBy")
  ]

-- | Declarations of the sample that use the UnliftIO version of a name
-- whose base version has a rule in @.hlint.yaml@.
unliftioDeclarations :: [Text]
unliftioDeclarations =
  [ "useCatch"
  , "useBracket"
  , "useFinally"
  , "useTry"
  , "useWithMVar"
  , "useModifyMVar"
  , "useTimeout"
  , "useMyThreadId"
  , "useDoesFileExist"
  ]
