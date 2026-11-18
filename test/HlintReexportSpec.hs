module HlintReexportSpec (spec) where

import Data.Set qualified as Set
import Data.Text qualified as T
import Himari
import HlintRunner
import Test.Syd

spec :: Spec
spec = do
  describe "hlint rules for symbols re-exported through himari" $ do
    describe "rules in .hlint.yaml" . beforeAll loadRestrictedFunctionNames $ do
      itWithOuter "rules for Himari should be exactly the tested functions" $ \names ->
        rulesThrough "Himari" names `shouldBe` reexportedFunctionNames

      itWithOuter "rules for Himari.Prelude should be exactly the tested functions" $ \names ->
        rulesThrough "Himari.Prelude" names `shouldBe` reexportedFunctionNames

      itWithOuter "rules for Himari.SafePrelude should leave out the functions it lacks" $ \names ->
        rulesThrough "Himari.SafePrelude" names
          `shouldBe` (reexportedFunctionNames `Set.difference` preludeOnlyFunctionNames)

    describe "import Himari" . withSample "ReexportHimari.hs" $ do
      describe "every restricted function re-exported by Himari should warn" $ do
        forM_ reexportedRestrictedFunctions $ \(declName, function, fragment) ->
          itWithOuter (convert function <> " should warn with its own message") $ \sample ->
            shouldWarnFunction sample declName function fragment

      describe "functions restricted by a rule without a module name should warn" $ do
        itWithOuter "throwString should warn" $ \sample ->
          shouldWarnFunction sample "useThrowString" "throwString" "typed exceptions with throwM"

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

-- | Module qualified names of the rules for the functions re-exported through the module.
-- Rules for the modules below it, such as @Himari.Prelude.head@ for @Himari@, are left out.
-- This does not support operators that contain a dot.
rulesThrough :: Text -> [Text] -> Set.Set Text
rulesThrough reexporter ruleNames =
  Set.fromList
    [ function
    | ruleName <- ruleNames
    , Just function <- [T.stripPrefix (reexporter <> ".") ruleName]
    , not ("." `T.isInfixOf` function)
    ]

-- | Names of the functions in 'reexportedRestrictedFunctions'.
reexportedFunctionNames :: Set.Set Text
reexportedFunctionNames =
  Set.fromList [function | (_, function, _) <- reexportedRestrictedFunctions]

-- | Functions re-exported by "Himari.Prelude" but not by "Himari.SafePrelude".
preludeOnlyFunctionNames :: Set.Set Text
preludeOnlyFunctionNames = Set.fromList ["stringException"]

-- | Declarations of the sample paired with the restricted function they use
-- and a fragment of the message of its rule.
-- These are all the functions that have a rule qualified with a module of himari in @.hlint.yaml@,
-- which is verified against @.hlint.yaml@ by the tests.
-- They are re-exported by "Himari" as the very same entity as the original one.
reexportedRestrictedFunctions :: [(Text, Text, Text)]
reexportedRestrictedFunctions =
  [ ("useHead", "head", "headMay")
  , ("useTail", "tail", "tailMay")
  , ("useInit", "init", "initMay")
  , ("useLast", "last", "lastMay")
  , ("useCycle", "cycle", "cycleMay")
  , ("useScanl1", "scanl1", "scanl1May")
  , ("useScanr1", "scanr1", "scanr1May")
  , ("useFoldl1", "foldl1", "foldl1May from Safe.Foldable")
  , ("useFoldr1", "foldr1", "foldr1May from Safe.Foldable")
  , ("useMaximum", "maximum", "maximumMay or maximumBound from Safe.Foldable")
  , ("useMinimum", "minimum", "minimumMay or minimumBound from Safe.Foldable")
  , ("useMaximumBy", "maximumBy", "maximumByMay or maximumBoundBy from Safe.Foldable")
  , ("useMinimumBy", "minimumBy", "minimumByMay or minimumBoundBy from Safe.Foldable")
  , ("useBifoldl1", "bifoldl1", "bifoldl with a default value")
  , ("useBifoldr1", "bifoldr1", "bifoldr with a default value")
  , ("useBimaximum", "bimaximum", "bifoldr with explicit initial value")
  , ("useBiminimum", "biminimum", "bifoldr with explicit initial value")
  , ("useBimaximumBy", "bimaximumBy", "bifoldr with explicit initial value")
  , ("useBiminimumBy", "biminimumBy", "bifoldr with explicit initial value")
  , ("useFromJust", "fromJust", "fromMaybe")
  , ("useGetChar", "getChar", "Encoding depends on LANG")
  , ("useGetLine", "getLine", "Encoding depends on LANG")
  , ("useGetContents", "getContents", "Use strict Text or ByteString")
  , ("useInteract", "interact", "Lazy IO + env-dependent encoding.")
  , ("useReadIO", "readIO", "partial (uses read)")
  , ("useReadLn", "readLn", "partial (uses read)")
  , ("usePutChar", "putChar", "Encoding depends on LANG")
  , ("usePutStr", "putStr", "Encoding depends on LANG")
  , ("usePutStrLn", "putStrLn", "Encoding depends on LANG")
  , ("usePrint", "print", "Encoding depends on LANG")
  , ("useReadFile", "readFile", "Data.Text.IO.readFile")
  , ("useWriteFile", "writeFile", "Data.Text.IO.writeFile")
  , ("useAppendFile", "appendFile", "Data.Text.IO.appendFile")
  , ("useSingular", "singular", "(^?)")
  , ("useUnsafeSingular", "unsafeSingular", "0 or >1 elements")
  , ("useUnsafePartsOf", "unsafePartsOf", "list length changes")
  , ("useIunsafePartsOf", "iunsafePartsOf", "list length changes")
  , ("useStringException", "stringException", "typed exceptions")
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
