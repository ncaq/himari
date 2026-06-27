module Anomaly
  ( AnomalySeverity (..)
  , AnomalyReport (..)
  , determineSeverity
  , formatReport
  ) where

import Data.Text qualified as T
import Himari

-- | Severity level of detected anomaly.
data AnomalySeverity
  = Normal
  | Warning
  | Critical
  | Catastrophic
  deriving (Bounded, Enum, Eq, Generic, Ord, Read, Show)

-- | Anomaly detection result.
data AnomalyReport = AnomalyReport
  { cpuUsage :: Double
  , threshold :: Double
  , severity :: AnomalySeverity
  , timestamp :: UTCTime
  }
  deriving (Eq, Generic, Ord, Read, Show)

-- | Determine severity based on how much the threshold is exceeded.
-- returns `Normal` when not exceeded
determineSeverity :: Double -> Double -> AnomalySeverity
determineSeverity threshold' usage
  | usage < threshold' = Normal
  | usage < threshold' + 5 = Warning
  | usage < threshold' + 15 = Critical
  | otherwise = Catastrophic

-- | Format anomaly report for logging.
formatReport :: AnomalyReport -> Text
formatReport report =
  mconcat
    [ "[ANOMALY DETECTED] "
    , "Severity: "
    , T.pack $ show report.severity
    , " | CPU: "
    , T.pack $ showFFloat (Just 1) report.cpuUsage "%"
    , " (threshold: "
    , T.pack $ showFFloat (Just 1) report.threshold "%"
    , ") | Time: "
    , T.pack $ formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S UTC" report.timestamp
    ]
