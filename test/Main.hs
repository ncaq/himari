module Main (main) where

import Himari
import Test.Syd
import TitleSpec qualified

main :: IO ()
main = sydTest $ do
  describe "Title" TitleSpec.spec
