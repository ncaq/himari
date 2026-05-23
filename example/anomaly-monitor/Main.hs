-- | Anomaly Monitoring System
--
-- An example application demonstrating himari usage.
-- Inspired by Akeboshi Himari from Blue Archive,
-- who leads the Paranormal Affairs Department at Millennium Science School.
--
-- This program monitors system metrics (CPU usage) and detects anomalies
-- when thresholds are exceeded.
module Main (main) where

import Env
import Himari
import Run

-- | Main entry point.
main :: IO ()
main = do
  initialEnv <- mkEnv
  runHimari initialEnv runAnomalyMonitor
