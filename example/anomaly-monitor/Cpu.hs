module Cpu
  ( CpuStats (..)
  , totalTime
  , idleTime
  , calculateCpuUsage
  , readCpuStats
  , showIOCpuThreshold
  ) where

import Config
import Data.Text qualified as T
import Data.Text.IO qualified as T
import Env
import Himari
import Numeric

-- | CPU time statistics from /proc/stat
data CpuStats = CpuStats
  { user :: Int
  , nice :: Int
  , system :: Int
  , idle :: Int
  , iowait :: Int
  , irq :: Int
  , softirq :: Int
  }
  deriving (Eq, Generic, Show)

-- | Parse CPU stats from /proc/stat content.
parseCpuStats :: Text -> Maybe CpuStats
parseCpuStats content = do
  -- Find the "cpu " line (aggregate of all CPUs)
  cpuLine <- find ("cpu " `T.isPrefixOf`) $ T.lines content
  let values = mapMaybe (readMay . convert) . drop 1 $ T.words cpuLine
  case values of
    (user' : nice' : system' : idle' : iowait' : irq' : softirq' : _) ->
      Just
        CpuStats
          { user = user'
          , nice = nice'
          , system = system'
          , idle = idle'
          , iowait = iowait'
          , irq = irq'
          , softirq = softirq'
          }
    _ -> Nothing

-- | Calculate total CPU time.
totalTime :: CpuStats -> Int
totalTime stats =
  sum
    [ stats.user
    , stats.nice
    , stats.system
    , stats.idle
    , stats.iowait
    , stats.irq
    , stats.softirq
    ]

-- | Calculate idle CPU time.
idleTime :: CpuStats -> Int
idleTime stats = stats.idle + stats.iowait

-- | Calculate CPU usage percentage between two measurements.
calculateCpuUsage :: CpuStats -> CpuStats -> Double
calculateCpuUsage prev curr =
  let totalDiff = totalTime curr - totalTime prev
      idleDiff = idleTime curr - idleTime prev
   in if totalDiff == 0
        then 0.0
        else 100.0 * fromIntegral (totalDiff - idleDiff) / fromIntegral totalDiff

-- | Read current CPU stats from /proc/stat.
readCpuStats :: (MonadLogger m, MonadUnliftIO m) => m (Maybe CpuStats)
readCpuStats = do
  contentEither <- tryAny . liftIO $ T.readFile "/proc/stat"
  case contentEither of
    Left exception -> do
      logWarnN $ "Failed to read /proc/stat: " <> convert (displayException exception)
      pure Nothing
    Right content -> pure $ parseCpuStats content

-- | Format CPU threshold and other config values as text.
showIOCpuThreshold :: (MonadIO m, MonadReader MonitorEnv m) => m Text
showIOCpuThreshold = do
  config' <- view config
  return $
    "Configuration: CPU threshold = "
      <> convert (showFFloat (Just 1) (config' ^. cpuThreshold) "%")
      <> ", interval = "
      <> convert (show $ config' ^. checkInterval)
      <> "s"
      <> ", max checks = "
      <> convert (show $ config' ^. maxChecks)
