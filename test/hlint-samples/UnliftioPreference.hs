{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE NoImplicitPrelude #-}

-- This file contains code patterns that should trigger hlint warnings
-- for preferring unliftio functions over standard library functions.
-- This file is excluded from treefmt checks via flake.nix settings.
module UnliftioPreference where

import Control.Concurrent.Async qualified as Async
import Control.Concurrent.MVar qualified as MVar
import Control.Exception qualified as Exception
import System.Timeout qualified as Timeout

-- Control.Concurrent.Async functions (should warn)
badAsync :: IO ()
badAsync = do
  _ <- Async.async (pure ())
  pure ()

badWithAsync :: IO ()
badWithAsync = Async.withAsync (pure ()) $ \_ -> pure ()

badRace :: IO ()
badRace = do
  _ <- Async.race (pure ()) (pure ())
  pure ()

badConcurrently :: IO ()
badConcurrently = do
  _ <- Async.concurrently (pure ()) (pure ())
  pure ()

badMapConcurrently :: IO ()
badMapConcurrently = do
  _ <- Async.mapConcurrently pure [1 :: Int, 2, 3]
  pure ()

-- Control.Exception functions (should warn)
badCatch :: IO ()
badCatch = Exception.catch (pure ()) (\(_ :: Exception.SomeException) -> pure ())

badBracket :: IO ()
badBracket = Exception.bracket (pure ()) (const (pure ())) (const (pure ()))

badFinally :: IO ()
badFinally = Exception.finally (pure ()) (pure ())

badTry :: IO (Either Exception.SomeException ())
badTry = Exception.try (pure ())

-- Control.Concurrent.MVar functions (should warn)
badWithMVar :: MVar.MVar () -> IO ()
badWithMVar mv = MVar.withMVar mv pure

badModifyMVar :: MVar.MVar () -> IO ()
badModifyMVar mv = MVar.modifyMVar_ mv pure

-- System.Timeout functions (should warn)
badTimeout :: IO (Maybe ())
badTimeout = Timeout.timeout 1000 (pure ())
