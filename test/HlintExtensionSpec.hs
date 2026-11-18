module HlintExtensionSpec (spec) where

import Himari
import HlintRunner
import Test.Syd

spec :: Spec
spec = do
  describe "hlint extension restriction rules" . withSample "ExtensionDangerous.hs" $ do
    describe "Dangerous extensions" $ do
      itWithOuter "AllowAmbiguousTypes should warn" $ \sample ->
        sample `shouldWarnExtension` "AllowAmbiguousTypes"

    describe "Discouraged extensions" $ do
      itWithOuter "ImplicitParams should warn" $ \sample ->
        sample `shouldWarnExtension` "ImplicitParams"

      itWithOuter "UndecidableInstances should warn" $ \sample ->
        sample `shouldWarnExtension` "UndecidableInstances"
