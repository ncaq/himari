-- | Anomaly Monitoring System
--
-- An example application demonstrating himari usage.
-- Inspired by Akeboshi Himari from Blue Archive,
-- who leads the Paranormal Affairs Department at Millennium Science School.
--
-- This program monitors system metrics (CPU usage) and detects anomalies
-- when thresholds are exceeded.
module Main (main) where

import Config
import Env
import Himari
import Run

-- | Main entry point.
main :: IO ()
main = do
  -- Get config file path from command line args (optional)
  args <- getArgs
  let logAction' = defaultOutput stderr
      configPath = listToMaybe args
  config' <- runSimpleEnv $ loadConfig configPath
  -- Create environment and run
  let initialEnv = MonitorEnv{logAction = logAction', config = config'}
  -- Load config within Himari monad, then update env
  runHimari initialEnv runAnomalyMonitor
