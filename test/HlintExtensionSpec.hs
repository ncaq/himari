module HlintExtensionSpec (spec) where

import Data.Text qualified as T
import Himari
import Test.Syd

spec :: Spec
spec = do
  describe "hlint extension restriction rules" . beforeAll runHlintOnSample $ do
    describe "Dangerous extensions" $ do
      itWithOuter "AllowAmbiguousTypes should warn" $ \output -> do
        output `shouldSatisfy` containsWarning "AllowAmbiguousTypes"

    describe "Deprecated extensions" $ do
      itWithOuter "ImplicitParams should warn" $ \output -> do
        output `shouldSatisfy` containsWarning "ImplicitParams"

      itWithOuter "UndecidableInstances should warn" $ \output -> do
        output `shouldSatisfy` containsWarning "UndecidableInstances"

runHlintOnSample :: IO Text
runHlintOnSample = do
  (exitCode, stdoutOutput, stderrOutput) <-
    readProcess $
      proc "hlint" ["test/HlintSamples/ExtensionDangerous.hs"]
  pure $ case exitCode of
    ExitSuccess -> convert stdoutOutput
    ExitFailure _ -> convert stdoutOutput <> convert stderrOutput

containsWarning :: Text -> Text -> Bool
containsWarning expectedMsg output = expectedMsg `T.isInfixOf` output
