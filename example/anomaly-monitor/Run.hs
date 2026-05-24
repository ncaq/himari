module Run
  ( runAnomalyMonitor
  ) where

import Banner
import Cpu
import Env
import Himari
import Loop

-- | Run application.
runAnomalyMonitor :: (MonadLogger m, MonadReader Env m, MonadUnliftIO m) => m ()
runAnomalyMonitor = do
  logInfoN "Initializing Anomaly Monitoring System..."
  printBanner
  cpuThresholdText <- showIOCpuThreshold
  logInfoN cpuThresholdText
  -- Read initial CPU stats
  maybeInitialStats <- readCpuStats
  case maybeInitialStats of
    Nothing -> logErrorN "Failed to read initial CPU stats. Is /proc/stat available?"
    Just initialStats -> do
      logInfoN "Starting monitoring loop..."
      monitorLoop initialStats 0
      logInfoN "Monitoring complete."
