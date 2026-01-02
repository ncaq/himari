-- | Aeson-related re-exports for JSON handling.
module Himari.Prelude.Aeson
  ( module Export
  ) where

-- aeson has many functions with common names that may conflict,
-- so we hide some and selectively import others.
import Data.Aeson as Export hiding
  ( decode
  , decode'
  , decodeFileStrict
  , decodeFileStrict'
  , decodeStrict
  , decodeStrict'
  , decodeStrictText
  , eitherDecode'
  , eitherDecodeFileStrict'
  , eitherDecodeStrict'
  , throwDecode'
  , throwDecodeStrict'
  , (.=)
  )
import Data.Aeson.Encode.Pretty as Export
  ( encodePretty
  , encodePretty'
  , encodePrettyToTextBuilder
  , encodePrettyToTextBuilder'
  )
import Data.Aeson.QQ.Simple as Export
import Deriving.Aeson as Export
