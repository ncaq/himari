{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Himari.Env.SimpleSpec (spec) where

import Himari
import Himari.Env.Simple
import Test.Syd

spec :: Spec
spec = do
  it "logging works" $
    (runSimpleEnv :: Himari SimpleEnv a -> IO a)
      ($(logDebug) "logging allowed")
