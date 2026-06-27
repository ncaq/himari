module Loop
  ( monitorLoop
  ) where

import Anomaly
import Config
import Cpu
import Data.Text qualified as T
import Env
import Himari

-- | Run monitoring loop.
monitorLoop
  :: (MonadLogger m, MonadReader Env m, MonadUnliftIO m)
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
        formattedReport <- mkFormattedReport usage cpuThreshold' severity'
        -- Log based on severity
        case severity' of
          Normal -> logDebugN $ "System normal. CPU: " <> T.pack (showFFloat (Just 1) usage "%")
          Warning -> logWarnN formattedReport
          Critical -> logErrorN formattedReport
          Catastrophic -> logErrorN $ "!!! " <> formattedReport <> " !!!"
        -- Continue monitoring
        monitorLoop currStats (checkCount + 1)
 where
  mkFormattedReport usage threshold' severity' = do
    now <- liftIO getCurrentTime
    return $
      formatReport
        AnomalyReport
          { cpuUsage = usage
          , threshold = threshold'
          , severity = severity'
          , timestamp = now
          }
