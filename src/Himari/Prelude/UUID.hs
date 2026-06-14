-- | Re-exports for UUID values and their generation.
-- "Data.UUID".
module Himari.Prelude.UUID
  ( module Export
  ) where

-- uuid exposes mostly safe total functions returning 'Maybe',
-- but some names are too generic and likely to conflict, so we hide only them.
-- @null@, @toString@, @fromString@, @toText@, @fromText@ conflict
-- with the @base@ and @text@ ecosystem,
-- and @toWords@, @fromWords@ conflict
-- with "Text.Casing" from 'Himari.Prelude.Casing'.
-- The hidden conversions are still usable via a qualified import of "Data.UUID".
import Data.UUID as Export hiding
  ( fromString
  , fromText
  , fromWords
  , null
  , toString
  , toText
  , toWords
  )

-- We will only re-export UUID modules that are practical.
import Data.UUID.V4 as Export
