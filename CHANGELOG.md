# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Haskell Package Versioning Policy](https://pvp.haskell.org/).

## [Unreleased]

## [1.0.0.1] - 2026-01-01

### Changed

- Move `-j` (parallel compilation) option from `himari.cabal` ghc-options to `cabal.project` to fix Hackage upload compatibility

## [1.0.0.0] - 2026-01-01

### Added

- `Himari` module that re-exports all submodules
- `Himari.Prelude` module as a custom Prelude
- `Himari.Char` module with `digitToIntMay`, `intToDigitMay`, `chrMay`
- `Himari.Env` module with `Himari` newtype, `runHimari`, `liftHimari`, `mapHimari`
- `Himari.Env.Simple` module with `SimpleEnv`, `runSimpleEnv`, `runSimpleEnvWith`
- `Himari.Logger` module with `HasLogAction` type class and `LogAction` type alias
- Re-exports from `Control.Lens`, `Control.Monad.*`, `Data.*`, `UnliftIO` in Prelude
- Re-exports from `safe`, `aeson`, `pretty-simple`, `monad-logger`, `typed-process` in Prelude
- Common type exports: `ByteString`, `Text`, `Vector`, `Map`, `HashMap`, etc.
- Bundled `.hlint.yaml` as `data-files` with comprehensive rules managed in Dhall
- HLint rules for partial function warnings in base, containers, text, bytestring, vector
- HLint rules for unsafe function warnings in primitive, UnliftIO
- HLint rules preferring UnliftIO over base IO modules
- HLint rules preferring typed-process over System.Process
- HLint rules preferring `convert` from convertible
- HLint rules preferring `pTrace*` over `Debug.Trace`
- HLint rules for qualified import naming conventions
- HLint rules for aeson, lens, mtl, yaml, and more
- Support for GHC 9.10.2, 9.10.3, and 9.12.2
- GHC2024 as the default language with `NoImplicitPrelude` extension
