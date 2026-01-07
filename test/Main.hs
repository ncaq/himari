module Main (main) where

import Himari
import Himari.CharSpec qualified as CharSpec
import Himari.Env.SimpleSpec qualified as SimpleSpec
import Himari.Prelude.FunctorSpec qualified as FunctorSpec
import HlintBaseSpec qualified
import HlintUnliftioSpec qualified
import Test.Syd
import TitleSpec qualified

main :: IO ()
main = sydTest $ do
  describe "Char" CharSpec.spec
  describe "Simple" SimpleSpec.spec
  describe "Title" TitleSpec.spec
  describe "Prelude.Functor" FunctorSpec.spec
  describe "HlintUnliftio" HlintUnliftioSpec.spec
  describe "HlintBase" HlintBaseSpec.spec
