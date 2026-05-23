module Env
  ( MonitorEnv (..)
  , HasLogAction (..)
  , HasConfig (..)
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
  monadLoggerLog loc src level msg = do
    logAction' <- view logAction
    liftIO . logAction' loc src level $ toLogStr msg
