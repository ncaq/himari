# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Haskell Package Versioning Policy](https://pvp.haskell.org/).

## [Unreleased]

## [1.1.6.1] - 2026-07-27

### Changed

- Stop preferring `convert` over total functions
  like `pack`, `unpack`, `toStrict`, `fromStrict`, `encodeUtf8`,
  and lazy/strict `Builder` conversions,
  because `convert` can be partial depending
  on the `Convertible` instance and this project avoids partial functions
- Warn against partial conversion functions like `decodeUtf8`
  with a message that recommends `safeConvert` from `Data.Convertible`,
  which returns `Either ConvertError` so the failure can be handled as a value
  rather than thrown. The rule is a usage restriction rather than a hint,
  since `safeConvert` is not a drop-in replacement (the return type changes)

## [1.1.6.0] - 2026-06-16

### Added

- hlint rule to import `Data.Containers.ListUtils` qualified as `L`,
  matching the alias used for `Data.List`

### Changed

- Relax the lower bound of the `uuid` dependency from `>=1.3.16.1` to `>=1.3.11`,
  the first version that provides all of the re-exported and hidden names

### Removed

- Stop distributing `.hlint.yaml` and `fourmolu.yaml` as Cabal `data-files`,
  since downstream usage cannot be verified.
  `.hlint.yaml` is kept under `extra-source-files` only because the test suite needs it

## [1.1.5.0] - 2026-06-14

### Added

- `casing` package (>=0.1.4.1) as a dependency for identifier case conversion
- `Himari.Prelude.Casing`: `Text.Casing` re-exports from the `casing` package
  (hiding the overly general `dropPrefix`, `toWords`, and `fromWords` to avoid name conflicts)
- `here` package (>=1.2.14) as a dependency for here documents and string interpolation
- `Himari.Prelude.Here`: `Data.String.Here` re-exports from the `here` package
  (hiding the overly general `i` and `template` to avoid name conflicts)
- `uuid` package (>=1.3.16.1) as a dependency for UUID values and their generation
- `Himari.Prelude.UUID`: `Data.UUID` and `Data.UUID.V4` re-exports
  from the `uuid` package
  (hiding the overly general:
  `null`,
  `toString`,
  `fromString`,
  `toText`,
  `fromText`,
  `fromWords`,
  `toWords`,
  to avoid name conflicts)

## [1.1.4.1] - 2026-06-13

### Changed

- Widen the `containers` version bound from `<0.8` to `<0.9`
  to allow `containers` 0.8, which ships with GHC 9.14.
- Switch dependency version bounds from the PVP caret operator (`^>=`)
  to explicit `>=x && <y` ranges.
  So that Renovate can recognize and update them.

## [1.1.4.0] - 2026-06-13

### Added

- `discardLogAction` export in `Himari.Logger`,
  a `LogAction` that discards all log output,
  useful for tests that should not write logs to the real terminal
- `runSimpleNoLogEnv` export in `Himari.Env.Simple`,
  a shorthand for `runSimpleEnvWith discardLogAction`
  that runs a `SimpleEnv` action while discarding all log output
- Re-export all public `time` modules that `Data.Time` itself does not re-export
  in `Himari.SafePrelude`:
  `Data.Time.Calendar.Easter`,
  `Data.Time.Calendar.Julian`,
  `Data.Time.Calendar.MonthDay`,
  `Data.Time.Calendar.Month`,
  `Data.Time.Calendar.OrdinalDate`,
  `Data.Time.Calendar.Quarter`,
  `Data.Time.Calendar.WeekDate`,
  `Data.Time.Clock.POSIX`,
  `Data.Time.Clock.System`,
  `Data.Time.Clock.TAI`,
  `Data.Time.Format.ISO8601`,
  and register them in the `fourmolu.yaml` `reexports` setting

### Changed

- Relax `aeson` dependency upper bound from `^>=2.2.3.0` to `^>=2.2.3.0 || ^>=2.3.0.0`
  to allow building against `aeson` 2.3.y.z

### Fixed

- Restructure the `fourmolu.yaml` `reexports` chain to match the module hierarchy
  introduced with `Himari.SafePrelude` in 1.1.3.0:
  re-exports that moved to `Himari.SafePrelude` are now registered under it
  instead of `Himari.Prelude`,
  and the previously missing `Data.Default` and `UnliftIO.Retry` entries are added

## [1.1.3.0] - 2026-05-30

### Added

- `Himari.SafePrelude`,
  a Safe Haskell-compatible subset of `Himari.Prelude` re-exported by `Himari.Prelude`,
  so downstream `Safe` modules can `import Himari.SafePrelude` directly
  without dragging in unsafe re-exports

### Changed

- Relax `data-default` dependency lower bound from `^>=0.8.0.2` to `^>=0.8.0.0`
  to widen the range of compatible `data-default` 0.8.x releases
- Remove `DerivingVia` and `TemplateHaskell` from `default-extensions`
  and enable them only in modules that use them,
  so `Safe` modules no longer need `NoDerivingVia` and `NoTemplateHaskell` overrides
- Promote `Himari.Char` and `Himari.Logger` from `Trustworthy` to `Safe`
  by switching them to import `Himari.SafePrelude` instead of `Himari.Prelude`

## [1.1.2.2] - 2026-05-28

### Changed

- Relax `time` dependency upper bound from `^>=1.12.2` to `>=1.12.2 && <2`
  to allow building against future `time` 1.x releases
- Declare `hlint ^>=3.10` as `build-tool-depends` for the test suite
  so `cabal test` no longer requires `hlint` to be pre-installed on `PATH`
- Constrain `ghc-lib-parser >=9.12.3` for the test suite under GHC `>=9.12.3`
  to avoid an unbuildable install plan with `ghc-lib-parser-9.12.2`
  (which fails on GHC `>=9.12.3` because `GHC.Internal.TH.Ppr` was removed).
  See <https://github.com/digital-asset/ghc-lib/issues/624>
  and <https://github.com/ndmitchell/hlint/pull/1696>

## [1.1.2.1] - 2026-05-25

### Added

- GHC 9.12.3 and 9.12.4 support

## [1.1.2.0] - 2026-05-25

### Added

- `mkSimpleEnv` export in `Himari.Env.Simple` to construct a `SimpleEnv`
  with the default settings separately from running it
- `defaultMonadLoggerLog` export in `Himari.Logger`,
  a reusable `monadLoggerLog` implementation for any `HasLogAction` environment
- `defaultLogAction` export in `Himari.Logger`
  for the default `LogAction` that writes to standard error
- Safe Haskell annotations.
  Modules that expose only safe APIs and import only safe modules are marked `Safe`;
  they disable `TemplateHaskell`, `DerivingVia`, and `GeneralizedNewtypeDeriving`,
  which are enabled globally but not allowed under Safe Haskell.
  Modules that expose only safe APIs but cannot be inferred `Safe`
  (because a dependency is not marked safe,
  or because they use Template Haskell or `GeneralizedNewtypeDeriving` internally)
  are marked `Trustworthy`.

## [1.1.1.0] - 2026-05-24

### Added

- `Numeric` re-export in `Himari.Prelude` for extra numeric functions
- HLint rules to warn against partial functions re-exported from `Numeric`:
  `showIntAtBase`, `showInt`, `showHex`, `showOct`, and `showBin`,
  which throw on negative (or invalid base) input

## [1.1.0.0] - 2026-04-11

### Added

- GHC 9.14.1 support

### Changed

- Relax `sydtest` dependency upper bound from `<0.19` to `<0.24`
  to support nixpkgs sydtest 0.20.0.1+

### Removed

- Drop Intel Mac (x86_64-darwin) from Nix build targets due
  to Nix ending support for this platform

## [1.0.5.0] - 2026-01-12

### Added

- `data-default` package (^>=0.8.0.2) as a dependency for default value support
- `Data.Default` re-export in `Himari.Prelude` for `Default` type class and `def` function
- `retry` package (^>=0.9.3.1) as a dependency for retry combinators
- `UnliftIO.Retry` re-export in `Himari.Prelude` for retry operations with exponential backoff
- HLint rules to warn against dangerous language extensions:
  `AllowAmbiguousTypes`,
  `DeferTypeErrors`,
  `ExtendedDefaultRules`,
  `ImpredicativeTypes`,
  `IncoherentInstances`,
  `LiberalTypeSynonyms`,
  `OverlappingInstances`,
  `RebindableSyntax`,
  `UndecidableSuperClasses`
- HLint rules to warn against discouraged language extensions:
  `ImplicitParams`,
  `UndecidableInstances`

### Changed

- Document recommended language extensions beyond GHC2024
  (e.g.,
  `BlockArguments`,
  `NoFieldSelectors`,
  `OverloadedStrings`,
  `StrictData`,
  etc.) with rationale for each
- Document extensions intentionally not enabled
  (e.g.,
  `Arrows`,
  `DeriveAnyClass`,
  `OverloadedLists`,
  `OverloadedRecordUpdate`,
  `Strict`,
  `UnicodeSyntax`
  ) with reasons
- Document dangerous language extensions that should be avoided:
  `AllowAmbiguousTypes`,
  `DeferTypeErrors`,
  `ExtendedDefaultRules`,
  `ImpredicativeTypes`,
  `IncoherentInstances`,
  `LiberalTypeSynonyms`,
  `OverlappingInstances`,
  `RebindableSyntax`,
  `UndecidableSuperClasses`
- Document discouraged language extensions that require caution:
  `ImplicitParams`,
  `UndecidableInstances`

## [1.0.4.0] - 2026-01-09

### Added

- `UnliftIO.Concurrent` re-export in `Himari.Prelude` for lifted concurrent operations
- `UnliftIO.Directory` re-export in `Himari.Prelude` for lifted directory operations
- `UnliftIO.Environment` re-export in `Himari.Prelude` for lifted environment operations
- `UnliftIO.Exception.Lens` re-export in `Himari.Prelude` for lens-based exception handling
- `UnliftIO.Foreign` is not re-exported to avoid `withArray` conflict with `Data.Aeson`
- `UnliftIO.IO.File` re-export in `Himari.Prelude` for atomic/durable file operations
- HLint rules: prefer `UnliftIO.Concurrent` over `Control.Concurrent`
- HLint rules: prefer `UnliftIO.Environment` over `System.Environment`
- HLint rules: prefer `UnliftIO.Exception.Lens` over `Control.Exception.Lens`
- HLint rule: restrict `forkOnWithUnmask` (exceptions don't propagate to parent thread)

### Changed

- `System.Process.Typed` hiding `setEnv` to prefer `UnliftIO.Environment.setEnv`
- `System.Process.Typed` is now re-exported via `Himari.Prelude.Process` instead of directly

## [1.0.3.2] - 2026-01-08

### Changed

- Fix HLint language extension configuration: use `arguments` with `-X` flags for parsing
  instead of `extensions` block (which is for restricting allowed extensions)
- Rename `hlint/rules/extensions.dhall` to `hlint/rules/parse-extensions.dhall`
- Remove `TemplateHaskell` from parse extensions (already enabled by default in HLint)

## [1.0.3.1] - 2026-01-08

### Added

- HLint language extension support in Dhall configuration
- Default language extensions for parsing:
  `QuasiQuotes`,
  `CPP`,
  `RecursiveDo`,
  `OverloadedRecordDot`,
  `OverloadedRecordUpdate`,
  `TemplateHaskell`,
  `BlockArguments`
- `ExtensionItem` type and helper functions
  (`extensionNames`, `extensionNamesWithin`, `extensions`)
  in `hlint/Builder.dhall`
- `hlint/rules/extensions.dhall` for managing default enabled extensions

## [1.0.3.0] - 2026-01-08

### Added

- `GHC.Stack` re-export in `Himari.Prelude` for call stack support (`HasCallStack`, etc.)
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
- Add `fourmolu.yaml` reexports and fixity settings to resolve operator precedence
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
- `Himari.Prelude.Type` module for type-only re-exports (`ByteString`, `Text`, `Map`, etc.)

### Changed

- Refactor `Himari.Prelude` to use submodules for cleaner Haddock documentation

## [1.0.0.1] - 2026-01-01

### Changed

- Move `-j` option from `himari.cabal` ghc-options to `cabal.project`
  to fix Hackage upload compatibility

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
