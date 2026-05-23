module Config
  ( MonitorConfig (..)
  , HasCpuThreshold (..)
  , HasCheckInterval (..)
  , HasMaxChecks (..)
  , loadConfig
  ) where

import Exception
import Himari

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

-- | Load configuration from file or use defaults.
loadConfig :: (MonadIO m, MonadLogger m, MonadThrow m) => Maybe FilePath -> m MonitorConfig
loadConfig maybePath = case maybePath of
  Nothing -> do
    logInfoN "No config file specified, using defaults"
    pure def
  Just path -> do
    logInfoN $ "Loading config from: " <> convert path
    contentEither <- liftIO $ eitherDecodeFileStrict path
    case contentEither of
      Left exception -> throwM . ConfigDecodeException $ convert exception
      Right config' -> pure config'
