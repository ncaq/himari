module Env
  ( MonitorEnv (..)
  , HasLogAction (..)
  , HasConfig (..)
  , newEnv
  ) where

import Config
import Himari

-- | Custom environment for the monitoring application.
-- This demonstrates how to create your own Env instead of using SimpleEnv.
data MonitorEnv = MonitorEnv
  { logAction :: LogAction
  -- ^ Log output function.
  , config :: MonitorConfig
  -- ^ Monitoring configuration.
  }
  deriving (Generic)

makeFieldsId ''MonitorEnv

-- | Enable MonadLogger for our custom environment.
-- This is the key instance that allows us to use logging functions.
instance MonadLogger (Himari MonitorEnv) where
  monadLoggerLog = defaultMonadLoggerLog

-- | Create the monitoring environment by loading configuration from command line arguments.
newEnv :: (MonadIO m) => m MonitorEnv
newEnv = do
  -- Get config file path from command line args (optional)
  args <- getArgs
  config' <- runSimpleEnv . loadConfig $ listToMaybe args
  return $ MonitorEnv{logAction = mkDefaultLogAction, config = config'}
