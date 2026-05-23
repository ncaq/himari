-- | Anomaly Monitoring System
--
-- An example application demonstrating himari usage.
-- Inspired by Akeboshi Himari from Blue Archive,
-- who leads the Paranormal Affairs Department at Millennium Science School.
--
-- This program monitors system metrics (CPU usage) and detects anomalies
-- when thresholds are exceeded.
module Main (main) where

import Banner
import Config
import Cpu
import Env
import Himari
import Loop

-- | Main entry point.
main :: IO ()
main = do
  printBanner
  -- Get config file path from command line args (optional)
  args <- getArgs
  let configPath = listToMaybe args
  -- Create environment and run
  let logAction' = defaultOutput stderr
      initialEnv = MonitorEnv{logAction = logAction', config = def}
  -- Load config within Himari monad, then update env
  runHimari initialEnv do
    logInfoN "Initializing Anomaly Monitoring System..."
    config' <- loadConfig configPath
    cpuThresholdText <- showIOCpuThreshold
    logInfoN cpuThresholdText
    -- Read initial CPU stats
    maybeInitialStats <- readCpuStats
    case maybeInitialStats of
      Nothing -> logErrorN "Failed to read initial CPU stats. Is /proc/stat available?"
      Just initialStats -> do
        logInfoN "Starting monitoring loop..."
        -- Run with updated config using local
        local (set config config') $ monitorLoop initialStats 0
        logInfoN "Monitoring complete."
