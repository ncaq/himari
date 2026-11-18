module HlintUnliftioSpec (spec) where

import Himari
import HlintRunner
import Test.Syd

spec :: Spec
spec = do
  describe "hlint unliftio preference rules" . withSample "UnliftioPreference.hs" $ do
    describe "Control" $ do
      describe "Exception" $ do
        itWithOuter "catch should warn to use UnliftIO.Exception" $ \sample ->
          shouldWarnFunction sample "badCatch" "Exception.catch" "UnliftIO.Exception.catch"

        itWithOuter "bracket should warn to use UnliftIO.Exception" $ \sample ->
          shouldWarnFunction sample "badBracket" "Exception.bracket" "UnliftIO.Exception.bracket"

        itWithOuter "finally should warn to use UnliftIO.Exception" $ \sample ->
          shouldWarnFunction sample "badFinally" "Exception.finally" "UnliftIO.Exception.finally"

        itWithOuter "try should warn to use UnliftIO.Exception" $ \sample ->
          shouldWarnFunction sample "badTry" "Exception.try" "UnliftIO.Exception.try"

      describe "Concurrent.MVar" $ do
        itWithOuter "withMVar should warn to use UnliftIO.MVar" $ \sample ->
          shouldWarnFunction sample "badWithMVar" "MVar.withMVar" "UnliftIO.MVar.withMVar"

        itWithOuter "modifyMVar_ should warn to use UnliftIO.MVar" $ \sample ->
          shouldWarnFunction sample "badModifyMVar" "MVar.modifyMVar_" "UnliftIO.MVar.modifyMVar_"

    describe "System.Timeout" $ do
      itWithOuter "timeout should warn to use UnliftIO.Timeout" $ \sample ->
        shouldWarnFunction sample "badTimeout" "Timeout.timeout" "UnliftIO.Timeout.timeout"
