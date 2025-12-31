{-# LANGUAGE OverloadedStrings #-}

module HlintUnliftioSpec (spec) where

import Data.Text qualified as T
import Himari
import Test.Syd

spec :: Spec
spec = do
  describe "hlint unliftio preference rules" . beforeAll runHlintOnSample $ do
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
      $ proc "hlint" ["test/HlintSamples/UnliftioPreference.hs"]
  pure $ case exitCode of
    ExitSuccess -> convert stdoutOutput
    ExitFailure _ -> convert stdoutOutput <> convert stderrOutput

containsWarning :: Text -> Text -> Bool
containsWarning expectedMsg output = expectedMsg `T.isInfixOf` output
