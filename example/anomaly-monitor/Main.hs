-- | Anomaly Monitoring System
--
-- An example application demonstrating himari usage.
-- Inspired by Akeboshi Himari from Blue Archive,
-- who leads the Paranormal Affairs Department at Millennium Science School.
--
-- This program monitors system metrics (CPU usage) and detects anomalies
-- when thresholds are exceeded.
module Main (main) where

import Data.ByteString.Lazy qualified as BL
import Data.Text qualified as T
import Himari
import Numeric (showFFloat)

-- * Configuration

-- | Monitoring configuration loaded from JSON file.
data MonitorConfig = MonitorConfig
  { cpuThreshold :: Double
  -- ^ CPU usage threshold percentage (0-100). Anomaly detected if exceeded.
  , checkInterval :: Int
  -- ^ Interval between checks in seconds.
  , maxChecks :: Int
  -- ^ Maximum number of checks to perform (0 = unlimited).
  }
  deriving stock (Eq, Generic, Show)
  deriving (FromJSON, ToJSON) via CustomJSON '[FieldLabelModifier '[CamelToSnake]] MonitorConfig

makeFieldsId ''MonitorConfig

-- | Default configuration when no config file is provided.
instance Default MonitorConfig where
  def =
    MonitorConfig
      { cpuThreshold = 80.0
      , checkInterval = 1
      , maxChecks = 5
      }

-- * Environment

-- | Custom environment for the monitoring application.
-- This demonstrates how to create your own Env instead of using SimpleEnv.
data MonitorEnv = MonitorEnv
  { logAction :: LogAction
  -- ^ Log output function.
  , config :: MonitorConfig
  -- ^ Monitoring configuration.
  }
  deriving stock (Generic)

makeFieldsId ''MonitorEnv

-- | Enable MonadLogger for our custom environment.
-- This is the key instance that allows us to use logging functions.
instance MonadLogger (Himari MonitorEnv) where
  monadLoggerLog loc src level msg = do
    logAction' <- view logAction
    liftIO . logAction' loc src level $ toLogStr msg

-- * CPU Monitoring

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
  deriving stock (Eq, Generic, Show)

-- | Parse CPU stats from /proc/stat content.
parseCpuStats :: Text -> Maybe CpuStats
parseCpuStats content = do
  -- Find the "cpu " line (aggregate of all CPUs)
  cpuLine <- find ("cpu " `T.isPrefixOf`) $ T.lines content
  let values = mapMaybe (readMay . convert @Text @String) . drop 1 $ T.words cpuLine
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
  stats.user + stats.nice + stats.system + stats.idle + stats.iowait + stats.irq + stats.softirq

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
readCpuStats :: (MonadIO m, MonadLogger m) => m (Maybe CpuStats)
readCpuStats = do
  contentEither <- liftIO . tryIO $ convert @String @Text <$> readFile "/proc/stat"
  case contentEither of
    Left exception -> do
      logWarnN $ "Failed to read /proc/stat: " <> convert (displayException exception)
      pure Nothing
    Right content -> pure $ parseCpuStats content

-- * Anomaly Detection

-- | Severity level of detected anomaly.
data AnomalySeverity
  = Normal
  | Warning
  | Critical
  | Catastrophic
  deriving stock (Eq, Ord, Show)

-- | Anomaly detection result.
data AnomalyReport = AnomalyReport
  { cpuUsage :: Double
  , threshold :: Double
  , severity :: AnomalySeverity
  , timestamp :: UTCTime
  }
  deriving stock (Eq, Generic, Show)

-- | Determine severity based on how much the threshold is exceeded.
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
    , convert $ show report.severity
    , " | CPU: "
    , convert $ showFFloat (Just 1) report.cpuUsage "%"
    , " (threshold: "
    , convert $ showFFloat (Just 1) report.threshold "%"
    , ") | Time: "
    , convert $ formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S UTC" report.timestamp
    ]

-- * Main Application

-- | Run monitoring loop.
monitorLoop
  :: (MonadIO m, MonadLogger m, MonadReader MonitorEnv m)
  => CpuStats
  -> Int
  -> m ()
monitorLoop prevStats checkCount = do
  config' <- view config
  let maxChecks' = config' ^. maxChecks
      interval = config' ^. checkInterval
      threshold' = config' ^. cpuThreshold

  -- Check if we should continue
  when (maxChecks' == 0 || checkCount < maxChecks') do
    -- Wait for interval
    threadDelay $ interval * 1_000_000

    -- Read new stats
    maybeStats <- readCpuStats
    case maybeStats of
      Nothing -> do
        logErrorN "Cannot read CPU stats, retrying..."
        monitorLoop prevStats checkCount
      Just currStats -> do
        let usage = calculateCpuUsage prevStats currStats
            severity' = determineSeverity threshold' usage

        -- Log based on severity
        case severity' of
          Normal ->
            logDebugN $ "System normal. CPU: " <> convert (showFFloat (Just 1) usage "%")
          Warning -> do
            report <- mkReport usage threshold' severity'
            logWarnN $ formatReport report
          Critical -> do
            report <- mkReport usage threshold' severity'
            logErrorN $ formatReport report
          Catastrophic -> do
            report <- mkReport usage threshold' severity'
            logErrorN $ "!!! " <> formatReport report <> " !!!"

        -- Continue monitoring
        monitorLoop currStats (checkCount + 1)
 where
  mkReport usage threshold'' severity' = do
    now <- liftIO getCurrentTime
    pure
      AnomalyReport
        { cpuUsage = usage
        , threshold = threshold''
        , severity = severity'
        , timestamp = now
        }

-- | Load configuration from file or use defaults.
loadConfig :: (MonadIO m, MonadLogger m) => Maybe FilePath -> m MonitorConfig
loadConfig maybePath = case maybePath of
  Nothing -> do
    logInfoN "No config file specified, using defaults"
    pure def
  Just path -> do
    logInfoN $ "Loading config from: " <> convert path
    contentEither <- liftIO . tryIO $ BL.readFile path
    case contentEither of
      Left exception -> do
        logWarnN $ "Failed to read config file: " <> convert (displayException exception)
        logWarnN "Using default configuration"
        pure def
      Right content -> case eitherDecode content of
        Left decodeError -> do
          logWarnN $ "Failed to parse config file: " <> convert decodeError
          logWarnN "Using default configuration"
          pure def
        Right config' -> do
          logInfoN "Configuration loaded successfully"
          pure config'

-- | Print banner.
printBanner :: (MonadIO m) => m ()
printBanner = liftIO $ putStrLn banner
 where
  banner =
    unlines
      [ "╔══════════════════════════════════════════════════════════════╗"
      , "║     Millennium Science School - Paranormal Affairs Dept.     ║"
      , "║           Anomaly Monitoring System v1.0                     ║"
      , "║                                                              ║"
      , "║  \"I am the all-knowing Himari! Leave system monitoring      ║"
      , "║   to me, Sensei!\"                                           ║"
      , "╚══════════════════════════════════════════════════════════════╝"
      ]

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
    logInfoN $
      "Configuration: CPU threshold = "
        <> convert (showFFloat (Just 1) (config' ^. cpuThreshold) "%")
        <> ", interval = "
        <> convert (show $ config' ^. checkInterval)
        <> "s"
        <> ", max checks = "
        <> convert (show $ config' ^. maxChecks)

    -- Read initial CPU stats
    maybeInitialStats <- readCpuStats
    case maybeInitialStats of
      Nothing -> logErrorN "Failed to read initial CPU stats. Is /proc/stat available?"
      Just initialStats -> do
        logInfoN "Starting monitoring loop..."
        -- Run with updated config using local
        local (set config config') $ monitorLoop initialStats 0
        logInfoN "Monitoring complete."
