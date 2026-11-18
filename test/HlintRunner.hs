-- | Helpers to run hlint on a sample file and assert on its structured output.
-- Assertions are keyed on declaration names instead of substrings of the whole output,
-- so a warning for one declaration can never satisfy an expectation for another one.
module HlintRunner
  ( Sample
  , withSample
  , loadRestrictedFunctionNames
  , shouldWarnFunction
  , shouldWarnFunctionOnce
  , shouldNotWarnFunctionIn
  , shouldSuggestIn
  , shouldWarnExtension
  ) where

import Data.Text qualified as T
import Data.Text.IO qualified as T
import Data.Yaml qualified as Yaml
import Himari
import Test.Syd

-- | A single hint reported by @hlint --json@.
data Idea = Idea
  { decl :: [Text]
  -- ^ Names of the declarations the hint belongs to.
  , severity :: Text
  -- ^ Severity of the hint. hlint reports a file it failed to parse as @Error@.
  , hint :: Text
  -- ^ Title of the hint such as @Avoid restricted function@.
  , from :: Text
  -- ^ Source fragment the hint points at.
  , note :: [Text]
  -- ^ Notes of the hint. The message of a restriction rule ends up here.
  , startLine :: Int
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON Idea

-- | A sample file together with the hints hlint reported for it.
data Sample = Sample
  { path :: FilePath
  , source :: Text
  , ideas :: [Idea]
  }
  deriving stock (Eq, Generic, Show)

-- | Run hlint with the project's @.hlint.yaml@ on a sample file.
-- hlint exits with a failure code when it reports hints, so the exit code is ignored.
-- A sample hlint failed to parse is rejected here,
-- because hlint reports nothing but the parse error for it
-- and every negative expectation on it would pass without checking anything.
loadSample :: FilePath -> IO Sample
loadSample path = do
  source <- T.readFile path
  (_, stdoutOutput, stderrOutput) <- readProcess $ proc "hlint" ["--json", path]
  case eitherDecode stdoutOutput of
    Right ideas -> case filter (\idea -> idea.severity == "Error") ideas of
      [] -> pure Sample{path, source, ideas}
      errors ->
        expectationFailure $
          "hlint reported errors for " <> path <> ": " <> show errors
    Left err ->
      expectationFailure $
        "failed to parse hlint output for "
          <> path
          <> ": "
          <> err
          <> "\n"
          <> T.unpack (convert stderrOutput)

-- | Run hlint once on a file of @test/HlintSamples@ and share the result among the tests.
withSample :: FilePath -> TestDefM '[Sample] () () -> Spec
withSample name = beforeAll (loadSample ("test/HlintSamples/" <> name))

-- | A rule of @.hlint.yaml@.
-- Only the function restrictions are read, the other kinds of rules have no @functions@ key.
newtype Rule = Rule
  { functions :: Maybe [FunctionRestriction]
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON Rule

-- | A function restriction of @.hlint.yaml@.
newtype FunctionRestriction = FunctionRestriction
  { name :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON FunctionRestriction

-- | Names of all the functions restricted by the project's @.hlint.yaml@.
loadRestrictedFunctionNames :: IO [Text]
loadRestrictedFunctionNames =
  Yaml.decodeFileEither ".hlint.yaml" >>= \case
    Right (rules :: [Rule]) ->
      pure [restriction.name | rule <- rules, restriction <- fold rule.functions]
    Left err ->
      expectationFailure $
        "failed to parse .hlint.yaml: " <> Yaml.prettyPrintParseException err

-- | Fail unless the sample defines the declaration.
-- This keeps negative expectations from passing vacuously
-- when a declaration is renamed or removed from the sample.
shouldDefine :: (HasCallStack) => Sample -> Text -> IO ()
shouldDefine sample declName =
  unless (any (T.isPrefixOf (declName <> " ::")) (T.lines sample.source)) . expectationFailure $
    sample.path <> " does not define " <> T.unpack declName

restrictedFunctionHint :: Text
restrictedFunctionHint = "Avoid restricted function"

-- | Restricted function warnings reported inside the declaration.
restrictedFunctionsIn :: Text -> Sample -> [Idea]
restrictedFunctionsIn declName sample =
  filter (\idea -> idea.hint == restrictedFunctionHint && declName `elem` idea.decl) sample.ideas

-- | Expect exactly one restricted function warning for the function inside the declaration.
expectSingleWarning :: (HasCallStack) => Sample -> Text -> Text -> IO Idea
expectSingleWarning sample declName function = do
  sample `shouldDefine` declName
  case filter (\idea -> idea.from == function) (restrictedFunctionsIn declName sample) of
    [idea] -> pure idea
    found ->
      expectationFailure $
        "expected exactly one restricted function warning for "
          <> T.unpack function
          <> " in "
          <> T.unpack declName
          <> ", but got "
          <> show found

-- | Expect the function used inside the declaration to be warned
-- with a message that contains the fragment.
shouldWarnFunction :: (HasCallStack) => Sample -> Text -> Text -> Text -> IO ()
shouldWarnFunction sample declName function fragment = do
  idea <- expectSingleWarning sample declName function
  idea.note `shouldSatisfy` any (T.isInfixOf fragment)

-- | Expect the function used inside the declaration to be warned with a single message.
-- hlint concatenates the messages of all matching rules without any separator,
-- so the message of a function matched by several rules contains the marker more than once.
shouldWarnFunctionOnce :: (HasCallStack) => Sample -> Text -> Text -> Text -> IO ()
shouldWarnFunctionOnce sample declName function marker = do
  idea <- expectSingleWarning sample declName function
  fmap (T.count marker) idea.note `shouldBe` [1]

-- | Expect no restricted function warning inside the declaration.
shouldNotWarnFunctionIn :: (HasCallStack) => Sample -> Text -> IO ()
shouldNotWarnFunctionIn sample declName = do
  sample `shouldDefine` declName
  restrictedFunctionsIn declName sample `shouldBe` []

-- | Expect a hint with the given title inside the declaration.
shouldSuggestIn :: (HasCallStack) => Sample -> Text -> Text -> IO ()
shouldSuggestIn sample declName hintTitle = do
  sample `shouldDefine` declName
  filter (\idea -> declName `elem` idea.decl) sample.ideas
    `shouldSatisfy` any (\idea -> idea.hint == hintTitle)

-- | Expect the language extension to be reported as restricted.
shouldWarnExtension :: (HasCallStack) => Sample -> Text -> IO ()
shouldWarnExtension sample extension =
  filter (\idea -> idea.hint == "Avoid restricted extensions") sample.ideas
    `shouldSatisfy` any (\idea -> ("LANGUAGE " <> extension <> " ") `T.isInfixOf` idea.from)
