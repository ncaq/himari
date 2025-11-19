{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Himari.Env.SimpleSpec (spec) where

import Himari
import Himari.Env.Simple
import Test.Syd

spec :: Spec
spec = do
  describe "logging" $ do
    it
      "outputs debug level logs"
      (runSimpleEnv $ $(logDebug) "debug message" :: IO ())

    it
      "outputs info level logs"
      (runSimpleEnv $ $(logInfo) "info message" :: IO ())

    it
      "outputs warning level logs"
      (runSimpleEnv $ $(logWarn) "warning message" :: IO ())

    it
      "outputs error level logs"
      (runSimpleEnv $ $(logError) "error message" :: IO ())

    it
      "handles multiple log calls"
      ( runSimpleEnv
          ( do
              $(logInfo) "first log"
              $(logInfo) "second log"
              $(logDebug) "third log"
          )
          :: IO ()
      )

    it "works with monadic composition" $ do
      result <- runSimpleEnv $ do
        $(logInfo) "starting computation"
        let x = 20 :: Int
        $(logDebug) ("intermediate value: " <> convert (show x))
        let y = x + 22
        $(logInfo) "computation complete"
        pure y
      result `shouldBe` 42

    it
      "supports monad-logger functions"
      ( runSimpleEnv
          ( do
              logInfoN "using logInfoN"
              logDebugN "using logDebugN"
              logWarnN "using logWarnN"
          )
          :: IO ()
      )

  describe "custom log output" $ do
    it "can capture log messages" $ do
      chan <- newTChanIO :: IO (TChan Text)
      let customLogOutput _h _loc _src _level msg = do
            let msgText = convert (fromLogStr msg)
            atomically $ writeTChan chan msgText
      runSimpleEnvWith customLogOutput stderr $ do
        $(logInfo) "custom output test"
      message <- atomically $ readTChan chan
      message `shouldBe` "custom output test"

    it "captures log level information" $ do
      chan <- newTChanIO :: IO (TChan (Text, LogLevel))
      let customLogOutput _h _loc _src level msg = do
            let msgText = convert (fromLogStr msg)
            atomically $ writeTChan chan (msgText, level)
      runSimpleEnvWith customLogOutput stderr $ do
        $(logError) "error log"
        $(logWarn) "warning log"
      msg1 <- atomically $ readTChan chan
      msg2 <- atomically $ readTChan chan
      [msg1, msg2] `shouldBe` [("error log", LevelError), ("warning log", LevelWarn)]

  describe "basic execution" $ do
    it "executes actions successfully" $ do
      result <- runSimpleEnv $ pure (42 :: Int)
      result `shouldBe` 42

    it "can access and use the environment" $ do
      result <- runSimpleEnv $ do
        $(logInfo) "computing result"
        pure (10 + 32 :: Int)
      result `shouldBe` 42
