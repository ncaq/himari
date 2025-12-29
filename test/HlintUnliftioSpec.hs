{-# LANGUAGE OverloadedStrings #-}

module HlintUnliftioSpec (spec) where

import Data.Text qualified as T
import Himari
import System.Process (readProcessWithExitCode)
import Test.Syd

spec :: Spec
spec = do
  describe "hlint unliftio preference rules" $ do
    it "Control.Concurrent.Async.async should warn to use UnliftIO.Async" $ do
      output <- runHlintOnSample
      output `shouldSatisfy` containsWarning "UnliftIO.Async.async"

    it "Control.Concurrent.Async.withAsync should warn to use UnliftIO.Async" $ do
      output <- runHlintOnSample
      output `shouldSatisfy` containsWarning "UnliftIO.Async.withAsync"

    it "Control.Concurrent.Async.race should warn to use UnliftIO.Async" $ do
      output <- runHlintOnSample
      output `shouldSatisfy` containsWarning "UnliftIO.Async.race"

    it "Control.Concurrent.Async.concurrently should warn to use UnliftIO.Async" $ do
      output <- runHlintOnSample
      output `shouldSatisfy` containsWarning "UnliftIO.Async.concurrently"

    it "Control.Concurrent.Async.mapConcurrently should warn to use UnliftIO.Async" $ do
      output <- runHlintOnSample
      output `shouldSatisfy` containsWarning "UnliftIO.Async.mapConcurrently"

    it "Control.Exception.catch should warn to use UnliftIO.Exception" $ do
      output <- runHlintOnSample
      output `shouldSatisfy` containsWarning "UnliftIO.Exception.catch"

    it "Control.Exception.bracket should warn to use UnliftIO.Exception" $ do
      output <- runHlintOnSample
      output `shouldSatisfy` containsWarning "UnliftIO.Exception.bracket"

    it "Control.Exception.finally should warn to use UnliftIO.Exception" $ do
      output <- runHlintOnSample
      output `shouldSatisfy` containsWarning "UnliftIO.Exception.finally"

    it "Control.Exception.try should warn to use UnliftIO.Exception" $ do
      output <- runHlintOnSample
      output `shouldSatisfy` containsWarning "UnliftIO.Exception.try"

    it "Control.Concurrent.MVar.withMVar should warn to use UnliftIO.MVar" $ do
      output <- runHlintOnSample
      output `shouldSatisfy` containsWarning "UnliftIO.MVar.withMVar"

    it "Control.Concurrent.MVar.modifyMVar_ should warn to use UnliftIO.MVar" $ do
      output <- runHlintOnSample
      output `shouldSatisfy` containsWarning "UnliftIO.MVar.modifyMVar_"

    it "System.Timeout.timeout should warn to use UnliftIO.Timeout" $ do
      output <- runHlintOnSample
      output `shouldSatisfy` containsWarning "UnliftIO.Timeout.timeout"

runHlintOnSample :: IO Text
runHlintOnSample = do
  (exitCode, stdoutOutput, stderrOutput) <-
    readProcessWithExitCode
      "hlint"
      ["test/hlint-samples/UnliftioPreference.hs"]
      ""
  pure $ case exitCode of
    ExitSuccess -> T.pack stdoutOutput
    ExitFailure _ -> T.pack stdoutOutput <> T.pack stderrOutput

containsWarning :: Text -> Text -> Bool
containsWarning expectedMsg output = expectedMsg `T.isInfixOf` output
