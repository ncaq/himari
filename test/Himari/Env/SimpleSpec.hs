{-# LANGUAGE TemplateHaskell #-}

module Himari.Env.SimpleSpec (spec) where

import Himari
import Test.Syd

spec :: Spec
spec = do
  -- テスト実行時に実際のターミナルへログを出力すると、
  -- Errorなどがログディスプレイでハイライトされて紛らわしいので、
  -- ログの出力を検証しないテストでは`discardLogAction`で出力を破棄する。
  describe "logging" $ do
    it
      "outputs debug level logs"
      (runSimpleEnvWith discardLogAction $ $(logDebug) "debug message" :: IO ())

    it
      "outputs info level logs"
      (runSimpleEnvWith discardLogAction $ $(logInfo) "info message" :: IO ())

    it
      "outputs warning level logs"
      (runSimpleEnvWith discardLogAction $ $(logWarn) "warning message" :: IO ())

    it
      "outputs error level logs"
      (runSimpleEnvWith discardLogAction $ $(logError) "error message" :: IO ())

    it
      "handles multiple log calls"
      ( runSimpleEnvWith
          discardLogAction
          ( do
              $(logInfo) "first log"
              $(logInfo) "second log"
              $(logDebug) "third log"
          )
          :: IO ()
      )

    it "works with monadic composition" $ do
      result <- runSimpleEnvWith discardLogAction $ do
        $(logInfo) "starting computation"
        let x = 20 :: Int
        $(logDebug) ("intermediate value: " <> convert (show x))
        let y = x + 22
        $(logInfo) "computation complete"
        pure y
      result `shouldBe` 42

    it
      "supports monad-logger functions"
      ( runSimpleEnvWith
          discardLogAction
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
      let customLogOutput _loc _src _level msg = do
            let msgText = convert (fromLogStr msg)
            atomically $ writeTChan chan msgText
      runSimpleEnvWith customLogOutput $ do
        $(logInfo) "custom output test"
      message <- atomically $ readTChan chan
      message `shouldBe` "custom output test"

    it "captures log level information" $ do
      chan <- newTChanIO :: IO (TChan (Text, LogLevel))
      let customLogOutput _loc _src level msg = do
            let msgText = convert (fromLogStr msg)
            atomically $ writeTChan chan (msgText, level)
      runSimpleEnvWith customLogOutput $ do
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
      result <- runSimpleEnvWith discardLogAction $ do
        $(logInfo) "computing result"
        pure (10 + 32 :: Int)
      result `shouldBe` 42

  describe "Magnify instance" $ do
    it "works with magnify to access a sub-environment" $ do
      let
        -- 小さな環境 (Text) を要求するアクション
        subAction :: Himari Text Text
        subAction = do
          env <- ask
          pure $ env <> " world"
        -- 大きな環境 (Int, Text)
        bigEnv :: (Int, Text)
        bigEnv = (100, "hello")
      -- (Int, Text) の環境下で、_2 レンズを使って Text にズームして実行
      -- これがコンパイル・実行できれば Effect IO へのマッピングは成功している
      result <- runHimari bigEnv $ magnify _2 subAction
      result `shouldBe` "hello world"
