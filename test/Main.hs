module Main (main) where

import Himari
import Himari.Env.SimpleSpec qualified as SimpleSpec
import Test.Syd
import TitleSpec qualified

main :: IO ()
main = sydTest $ do
  describe "Simple" SimpleSpec.spec
  describe "Title" TitleSpec.spec
