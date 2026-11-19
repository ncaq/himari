module Main (main) where

import Data.ByteString qualified as B
import Data.ByteString.Lazy qualified as BL
import Data.Text qualified as T
import Data.Text.Encoding qualified as TE
import Data.Text.IO.Utf8 qualified as TO
import Data.Yaml qualified as Yaml
import Dhall.Binary qualified
import Dhall.Core qualified
import Dhall.Import qualified
import Dhall.Parser qualified
import GenerateHlint
import GenerateHlint.Check
import GenerateHlint.Exception
import GenerateHlint.Formatter
import GenerateHlint.Generate
import GenerateHlint.Path
import GenerateHlint.Yaml
import Himari
import Test.Syd

-- | Dhallソースを1つだけ持つ一時的なプロジェクトルートを作ってテストを実行します。
withProject :: Text -> (FilePath -> IO a) -> IO a
withProject source action =
  withSystemTempDirectory "generate-hlint-test" \root -> do
    createDirectoryIfMissing True (root </> takeDirectory dhallSourcePath)
    TO.writeFile (root </> dhallSourcePath) source
    action root

-- | リモートのimportを含まない小さなルール。
-- `None`のフィールドとYAMLでクォートが必要な文字列を含みます。
sampleSource :: Text
sampleSource =
  T.unlines
    [ "[ { hint = { lhs = \"foo x\", rhs = \"bar x\", note = None Text } }"
    , ", { hint = { lhs = \"a: b\", rhs = \"'quoted'\", note = Some \"- note\" } }"
    , "]"
    ]

sampleRules :: Value
sampleRules =
  [aesonQQ|
    [ { "hint": { "lhs": "foo x", "rhs": "bar x" } }
    , { "hint": { "lhs": "a: b", "rhs": "'quoted'", "note": "- note" } }
    ]
  |]

-- | キャッシュに存在しないリモートのimport。
remoteSource :: Text
remoteSource =
  "https://example.invalid/package.dhall\n  sha256:" <> T.replicate 64 "0" <> "\n"

-- | 何も整形しないフォーマッター。
-- テストの実行環境にはtreefmtが無いので、整形以外の流れをこれで検査します。
-- treefmtを使った生成は`nix flake check`の`hlint-yaml-up-to-date`が検査します。
unformatted :: Formatter IO
unformatted _ = pure

-- | 指定したパスを読み取り専用にして処理を実行します。
-- 一時ディレクトリを削除できるように、処理が終わったら書き込めるように戻します。
withReadOnly :: [FilePath] -> IO a -> IO a
withReadOnly paths = bracket_ (setWritable False) (setWritable True)
 where
  setWritable writable =
    for_ paths \path -> getPermissions path >>= setPermissions path . setOwnerWritable writable

isRemoteImportNotCached :: GenerateHlintException -> Bool
isRemoteImportNotCached = \case
  RemoteImportNotCached url -> "example.invalid" `T.isInfixOf` url
  _ -> False

isOutOfDate :: GenerateHlintException -> Bool
isOutOfDate = \case
  HlintYamlOutOfDate _ difference -> "stale" `T.isInfixOf` difference
  _ -> False

-- | オフラインのimportのテストがプロセスの環境変数を一時的に書き換えるので、
-- 全てのテストを直列に実行します。
main :: IO ()
main = sydTest . sequential $ do
  describe "generate" $ do
    it "starts with the header comment" $ withProject sampleSource \root -> do
      generated <- generate unformatted Nothing root
      generated `shouldSatisfy` B.isPrefixOf (TE.encodeUtf8 header)

    it "writes YAML equivalent to the Dhall rules without None fields" $
      withProject sampleSource \root -> do
        generated <- generate unformatted Nothing root
        case Yaml.decodeEither' generated of
          Right (decoded :: Value) -> decoded `shouldBe` sampleRules
          Left err -> expectationFailure $ Yaml.prettyPrintParseException err

    it "rejects rules that are not a list" $ withProject "{ group = True }" \root ->
      generate unformatted Nothing root `shouldThrow` (== RulesNotList)

    it "reports a missing Dhall source" $
      withSystemTempDirectory "generate-hlint-test" \root ->
        generate unformatted Nothing root
          `shouldThrow` (== DhallSourceNotFound (root </> dhallSourcePath))

    it "passes the output path and the rendered YAML to the formatter" $
      withProject sampleSource \root -> do
        let formatter path content = do
              path `shouldBe` root </> hlintYamlPath
              pure $ content <> "# formatted\n"
        generated <- generate formatter Nothing root
        generated `shouldSatisfy` B.isSuffixOf "# formatted\n"

    it "rejects a formatter that changes the meaning of the YAML" $
      withProject sampleSource \root ->
        generate (\_ _ -> pure "[]\n") Nothing root `shouldThrow` (== GeneratedYamlChanged)

  describe "treefmtWith" $ do
    it "reports a command that cannot be started" $
      withSystemTempDirectory "generate-hlint-test" \root ->
        treefmtWith "generate-hlint-test-missing-command" (root </> hlintYamlPath) "[]\n"
          `shouldThrow` \case
            FormatterNotStarted _ -> True
            _ -> False

    it "reports the exit code of a failed command" $
      withSystemTempDirectory "generate-hlint-test" \root ->
        treefmtWith "false" (root </> hlintYamlPath) "[]\n"
          `shouldThrow` \case
            FormatterFailed code _ -> code == 1
            _ -> False

  describe "offline import" $ do
    it "resolves a cached remote import from a read-only cache without the network" $ do
      parsed <- either throwM pure $ Dhall.Parser.exprFromText "(sample)" sampleSource
      resolved <- Dhall.Import.assertNoImports parsed
      let expression :: Dhall.Core.Expr Void Void
          expression = Dhall.Core.alphaNormalize $ Dhall.Core.normalize resolved
          digest = show $ Dhall.Import.hashExpression expression
          source = "https://example.invalid/package.dhall\n  sha256:" <> T.pack digest <> "\n"
      withProject source \root ->
        withSystemTempDirectory "generate-hlint-test-cache" \cache -> do
          -- Dhallのキャッシュのファイル名は`1220`にsha256のハッシュを続けたものです。
          let cacheFile = cache </> ("1220" <> digest)
          B.writeFile cacheFile . BL.toStrict $ Dhall.Binary.encodeExpression expression
          -- ファイルではないものは読み飛ばされることも確かめます。
          createDirectory (cache </> "subdirectory")
          generated <-
            withReadOnly [cacheFile, cache] $ generate unformatted (Just cache) root
          case Yaml.decodeEither' generated of
            Right (decoded :: Value) -> decoded `shouldBe` sampleRules
            Left err -> expectationFailure $ Yaml.prettyPrintParseException err

    it "fails with the URL instead of accessing the network on a cache miss" $
      withProject remoteSource \root ->
        withSystemTempDirectory "generate-hlint-test-cache" \cache ->
          generate unformatted (Just cache) root `shouldThrow` isRemoteImportNotCached

    it "restores XDG_CACHE_HOME after the generation" $ withProject sampleSource \root ->
      withSystemTempDirectory "generate-hlint-test-cache" \cache -> do
        original <- lookupEnv "XDG_CACHE_HOME"
        _ <- generate unformatted (Just cache) root
        lookupEnv "XDG_CACHE_HOME" `shouldReturn` original

    it "reports a missing cache directory" $ withProject sampleSource \root ->
      generate unformatted (Just (root </> "missing")) root
        `shouldThrow` (== DhallCacheNotFound (root </> "missing"))

  describe "check" $ do
    it "accepts the generated file" $ withProject sampleSource \root -> do
      generate unformatted Nothing root >>= B.writeFile (root </> hlintYamlPath)
      check unformatted Nothing root

    it "rejects a stale file with the difference" $ withProject sampleSource \root -> do
      B.writeFile (root </> hlintYamlPath) "- stale: true\n"
      check unformatted Nothing root `shouldThrow` isOutOfDate

    it "reports a missing file" $ withProject sampleSource \root ->
      check unformatted Nothing root `shouldThrow` (== HlintYamlNotFound (root </> hlintYamlPath))

  describe "runWith" $ do
    it "writes the generated file" $ withProject sampleSource \root -> do
      runWith unformatted Options{projectRoot = Just root, dhallCache = Nothing, checkOnly = False}
      generated <- generate unformatted Nothing root
      B.readFile (root </> hlintYamlPath) `shouldReturn` generated

    it "does not write in check mode" $ withProject sampleSource \root -> do
      let stale = "- stale: true\n"
      B.writeFile (root </> hlintYamlPath) stale
      runWith unformatted Options{projectRoot = Just root, dhallCache = Nothing, checkOnly = True}
        `shouldThrow` isOutOfDate
      B.readFile (root </> hlintYamlPath) `shouldReturn` stale

    it "passes an absolute path to the formatter for a relative project root" $
      withProject sampleSource \root -> do
        formattedPath <- newIORef Nothing
        let formatter path content = do
              writeIORef formattedPath (Just path)
              pure content
        withCurrentDirectory (takeDirectory root) $
          runWith
            formatter
            Options{projectRoot = Just (takeFileName root), dhallCache = Nothing, checkOnly = False}
        readIORef formattedPath `shouldReturn` Just (root </> hlintYamlPath)

  describe "findProjectRoot" $ do
    it "finds the root from a nested directory" $ withProject sampleSource \root -> do
      let nested = root </> "a" </> "b"
      createDirectoryIfMissing True nested
      findProjectRoot nested `shouldReturn` root

    it "fails when no ancestor has the Dhall source" $
      withSystemTempDirectory "generate-hlint-test" \dir ->
        findProjectRoot dir `shouldThrow` (== ProjectRootNotFound dir)
