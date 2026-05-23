module Loop
  ( monitorLoop
  ) where

import Anomaly
import Config
import Cpu
import Env
import Himari
import Numeric

-- | Run monitoring loop.
monitorLoop
  :: (MonadLogger m, MonadReader MonitorEnv m, MonadUnliftIO m)
  => CpuStats
  -> Int
  -> m ()
monitorLoop prevStats checkCount = do
  MonitorConfig
    { cpuThreshold = cpuThreshold'
    , checkInterval = checkInterval'
    , maxChecks = maxChecks'
    } <-
    view config
  -- Check if we should continue
  when (maxChecks' == 0 || checkCount < maxChecks') do
    -- Wait for checkInterval'
    threadDelay $ checkInterval' * 1_000_000
    -- Read new stats
    maybeStats <- readCpuStats
    case maybeStats of
      Nothing -> do
        logErrorN "Cannot read CPU stats, retrying..."
        monitorLoop prevStats checkCount
      Just currStats -> do
        let usage = calculateCpuUsage prevStats currStats
            severity' = determineSeverity cpuThreshold' usage
        -- Log based on severity
        case severity' of
          Normal ->
            logDebugN $ "System normal. CPU: " <> convert (showFFloat (Just 1) usage "%")
          Warning -> do
            report <- mkReport usage cpuThreshold' severity'
            logWarnN $ formatReport report
          Critical -> do
            report <- mkReport usage cpuThreshold' severity'
            logErrorN $ formatReport report
          Catastrophic -> do
            report <- mkReport usage cpuThreshold' severity'
            logErrorN $ "!!! " <> formatReport report <> " !!!"
        -- Continue monitoring
        monitorLoop currStats (checkCount + 1)
 where
  mkReport usage threshold' severity' = do
    now <- liftIO getCurrentTime
    pure
      AnomalyReport
        { cpuUsage = usage
        , threshold = threshold'
        , severity = severity'
        , timestamp = now
        }
