module Main (main) where

import Himari
import Himari.Env.SimpleSpec qualified as SimpleSpec
import HlintBaseSpec qualified
import HlintUnliftioSpec qualified
import Test.Syd
import TitleSpec qualified

main :: IO ()
main = sydTest $ do
  describe "Simple" SimpleSpec.spec
  describe "Title" TitleSpec.spec
  describe "HlintUnliftio" HlintUnliftioSpec.spec
  describe "HlintBase" HlintBaseSpec.spec
