{-# LANGUAGE OverloadedStrings #-}

module HlintUnliftioSpec (spec) where

import Data.ByteString.Lazy qualified as LBS
import Data.Text qualified as T
import Data.Text.Encoding qualified as TE
import Himari
import Test.Syd

spec :: Spec
spec = do
  describe "hlint unliftio preference rules" . beforeAll runHlintOnSample $ do
    itWithOuter "Control.Concurrent.Async.async should warn to use UnliftIO.Async" $ \output -> do
      output `shouldSatisfy` containsWarning "UnliftIO.Async.async"

    itWithOuter "Control.Concurrent.Async.withAsync should warn to use UnliftIO.Async" $ \output -> do
      output `shouldSatisfy` containsWarning "UnliftIO.Async.withAsync"

    itWithOuter "Control.Concurrent.Async.race should warn to use UnliftIO.Async" $ \output -> do
      output `shouldSatisfy` containsWarning "UnliftIO.Async.race"

    itWithOuter "Control.Concurrent.Async.concurrently should warn to use UnliftIO.Async" $ \output -> do
      output `shouldSatisfy` containsWarning "UnliftIO.Async.concurrently"

    itWithOuter "Control.Concurrent.Async.mapConcurrently should warn to use UnliftIO.Async" $ \output -> do
      output `shouldSatisfy` containsWarning "UnliftIO.Async.mapConcurrently"

    itWithOuter "Control.Exception.catch should warn to use UnliftIO.Exception" $ \output -> do
      output `shouldSatisfy` containsWarning "UnliftIO.Exception.catch"

    itWithOuter "Control.Exception.bracket should warn to use UnliftIO.Exception" $ \output -> do
      output `shouldSatisfy` containsWarning "UnliftIO.Exception.bracket"

    itWithOuter "Control.Exception.finally should warn to use UnliftIO.Exception" $ \output -> do
      output `shouldSatisfy` containsWarning "UnliftIO.Exception.finally"

    itWithOuter "Control.Exception.try should warn to use UnliftIO.Exception" $ \output -> do
      output `shouldSatisfy` containsWarning "UnliftIO.Exception.try"

    itWithOuter "Control.Concurrent.MVar.withMVar should warn to use UnliftIO.MVar" $ \output -> do
      output `shouldSatisfy` containsWarning "UnliftIO.MVar.withMVar"

    itWithOuter "Control.Concurrent.MVar.modifyMVar_ should warn to use UnliftIO.MVar" $ \output -> do
      output `shouldSatisfy` containsWarning "UnliftIO.MVar.modifyMVar_"

    itWithOuter "System.Timeout.timeout should warn to use UnliftIO.Timeout" $ \output -> do
      output `shouldSatisfy` containsWarning "UnliftIO.Timeout.timeout"

runHlintOnSample :: IO Text
runHlintOnSample = do
  (exitCode, stdoutOutput, stderrOutput) <-
    readProcess
      $ proc "hlint" ["test/hlint-samples/UnliftioPreference.hs"]
  let decodeOutput = TE.decodeUtf8 . LBS.toStrict
  pure $ case exitCode of
    ExitSuccess -> decodeOutput stdoutOutput
    ExitFailure _ -> decodeOutput stdoutOutput <> decodeOutput stderrOutput

containsWarning :: Text -> Text -> Bool
containsWarning expectedMsg output = expectedMsg `T.isInfixOf` output
