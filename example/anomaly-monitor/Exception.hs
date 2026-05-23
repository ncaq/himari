module Exception
  ( AnomalyMonitorException (..)
  ) where

import Himari

newtype AnomalyMonitorException
  = ConfigDecodeException Text
  deriving (Eq, Generic, Show)

instance Exception AnomalyMonitorException
