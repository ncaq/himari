# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Haskell Package Versioning Policy](https://pvp.haskell.org/).

## [Unreleased]

### Added

- HLint language extension support in Dhall configuration
- Default language extensions for parsing: `QuasiQuotes`, `CPP`, `RecursiveDo`, `OverloadedRecordDot`,
  `OverloadedRecordUpdate`, `TemplateHaskell`, `BlockArguments`
- `ExtensionItem` type and helper functions (`extensionNames`, `extensionNamesWithin`, `extensions`)
  in `hlint/Builder.dhall`
- `hlint/rules/extensions.dhall` for managing default enabled extensions

## [1.0.3.0] - 2026-01-08

### Added

- `GHC.Stack` re-export in `Himari.Prelude` for call stack support (`HasCallStack`, `CallStack`, etc.)
- HLint rule for `errorWithStackTrace` (deprecated function warning)

## [1.0.2.0] - 2026-01-07

### Added

- `Himari.Prelude.Arrow`: `Control.Arrow` re-exports (hiding conflicting symbols)
- `Himari.Prelude.Catch`: `Control.Monad.Catch` re-exports (hiding UnliftIO conflicts)
- `Himari.Prelude.Data`: `Data.Data` re-exports (hiding GHC.Generics conflicts)
- `Himari.Prelude.Monoid`: `Data.Monoid`/`Data.Semigroup` re-exports (hiding conflicts)
- `Himari.Prelude.TypeLevel`: type-level programming (`Data.Type.Coercion`, `Data.Type.Equality`)
- `Himari.Prelude.FunctorSpec`: test module for functor-related exports
- `Control.Arrow` re-export in `Himari.Prelude` (via `Himari.Prelude.Arrow`)
- `Data.Coerce` re-export in `Himari.Prelude` for safe type coercion
- `Data.Complex` re-export in `Himari.Prelude` for complex number support
- `Data.Data` re-export in `Himari.Prelude` (via `Himari.Prelude.Data`) for generic programming
- `Data.Fixed` re-export in `Himari.Prelude` for fixed-point arithmetic
- `Data.Functor.Compose` re-export in `Himari.Prelude` for functor composition
- `Data.Int` re-export in `Himari.Prelude` for sized integer types
- `Data.Kind` re-export in `Himari.Prelude` for kind-level types (`Type`, `Constraint`)
- `Data.Monoid`/`Data.Semigroup` re-export in `Himari.Prelude` (via `Himari.Prelude.Monoid`)
- `Data.Proxy` re-export in `Himari.Prelude` for type-level proxy values
- `Data.Type.Coercion`/`Data.Type.Equality` re-export (via `Himari.Prelude.TypeLevel`)
- `Numeric.Natural` re-export in `Himari.Prelude` for non-negative integers

### Changed

- `Himari.Prelude.Aeson`: Hide overly general symbols
- `Himari.Prelude.Catch`: Hide `Handler` to avoid conflicts

## [1.0.1.0] - 2026-01-06

### Added

- Added `Magnify` instance for `Himari` monad
- Bundle `fourmolu.yaml` in Cabal `data-files` so downstream users can reuse the formatter config
- Add `fourmolu.yaml` reexports and fixity settings to resolve operator precedence for Himari’s Prelude
- Document setup steps in README for copying/merging `.hlint.yaml` and `fourmolu.yaml`
- Add fourmolu customization notes to README

## [1.0.0.2] - 2026-01-03

### Added

- Support for Windows
- Support for macOS (x86_64-darwin, aarch64-darwin) and Linux ARM (aarch64-linux)
- `Himari.Prelude.Aeson` module for JSON-related re-exports
- `Himari.Prelude.Safe` module for safe function re-exports
- `Himari.Prelude.Category` module for `Control.Category` re-exports (hiding `id` and `.`)
- `Himari.Prelude.Generics` module for `GHC.Generics` re-exports (hiding `from` and `to`)
- `Himari.Prelude.FilePath` module for `System.FilePath` re-exports (hiding `<.>`)
- `Himari.Prelude.Type` module for type-only re-exports (`ByteString`, `Text`, `Map`, `Vector`, etc.)

### Changed

- Refactor `Himari.Prelude` to use submodules for cleaner Haddock documentation

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
