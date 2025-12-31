-- This file contains code patterns that should trigger hlint warnings
-- for preferring unliftio functions over standard library functions.
module HlintSamples.UnliftioPreference where

import Control.Concurrent.MVar qualified as MVar
import Control.Exception qualified as Exception
import Himari
import System.Timeout qualified as Timeout

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
