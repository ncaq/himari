{-# LANGUAGE OverloadedStrings #-}

module HlintBaseSpec (spec) where

import Data.Text qualified as T
import Himari
import Test.Syd

spec :: Spec
spec = do
  describe "hlint base library rules" . beforeAll runHlintOnSample $ do
    describe "Data.List partial functions" $ do
      itWithOuter "Data.List.head should warn (partial function)" $ \output -> do
        output `shouldSatisfy` containsWarning "headMay"

    describe "NonEmpty.head should be safe" $ do
      itWithOuter "Data.List.NonEmpty.head should NOT warn (it's safe)" $ \output -> do
        output `shouldSatisfy` notContainsWarningAt "useNonEmptyHead"

    describe "Debug.Trace functions suggest pTrace*" $ do
      itWithOuter "Debug.Trace.trace should suggest pTrace" $ \output -> do
        output `shouldSatisfy` containsWarningAt "trace" "pTrace"

      itWithOuter "Debug.Trace.traceShow should suggest pTraceShow" $ \output -> do
        output `shouldSatisfy` containsWarningAt "traceShow" "pTraceShow"

      itWithOuter "Debug.Trace.traceM should suggest pTraceM" $ \output -> do
        output `shouldSatisfy` containsWarningAt "traceM" "pTraceM"

runHlintOnSample :: IO Text
runHlintOnSample = do
  (exitCode, stdoutOutput, stderrOutput) <-
    readProcess
      $ proc "hlint" ["test/HlintSamples/BasePartial.hs"]
  pure $ case exitCode of
    ExitSuccess -> convert stdoutOutput
    ExitFailure _ -> convert stdoutOutput <> convert stderrOutput

containsWarning :: Text -> Text -> Bool
containsWarning expectedMsg output = expectedMsg `T.isInfixOf` output

containsWarningAt :: Text -> Text -> Text -> Bool
containsWarningAt funcName expectedMsg output =
  let msgAndFunc = funcName `T.isInfixOf` output && expectedMsg `T.isInfixOf` output
   in msgAndFunc

notContainsWarningAt :: Text -> Text -> Bool
notContainsWarningAt funcName output =
  let linesWithFunc =
        filter (T.isInfixOf funcName) (T.lines output)
   in null linesWithFunc
