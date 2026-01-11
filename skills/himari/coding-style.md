# Himari Haskell Coding Style

## 言語拡張

### 使用禁止の言語拡張

以下の言語拡張は危険なため使用禁止:

- `AllowAmbiguousTypes` - 型推論を困難にする
- `ImplicitParams` - 暗黙の引数は追跡が困難
- `ImpredicativeTypes` - 型システムを複雑化
- `IncoherentInstances` - インスタンス選択が不定
- `LiberalTypeSynonyms` - 型の安全性を損なう
- `OverlappingInstances` - インスタンス選択が曖昧
- `RebindableSyntax` - コードの可読性を損なう
- `UndecidableInstances` - 型チェックが停止しない可能性
- `UndecidableSuperClasses` - 型チェックが停止しない可能性

## 関数の使用制限

### 絶対禁止

```haskell
-- これらは使用禁止
unsafeDupablePerformIO
unsafeFixIO
unsafeInterleaveIO
unsafePerformIO
```

### 部分関数の禁止

```haskell
-- 禁止: 失敗時に例外を投げる
fromJust :: Maybe a -> a
read :: Read a => String -> a
head :: [a] -> a
tail :: [a] -> [a]
(!!) :: [a] -> Int -> a

-- 代替案を使用
readMay :: Read a => String -> Maybe a
listToMaybe :: [a] -> Maybe a
```

### `error`関数の禁止

純粋関数空間での`error`使用は禁止。代わりに:

```haskell
-- 禁止
calculate :: Int -> Int
calculate x
  | x < 0 = error "negative input"
  | otherwise = x * 2

-- 推奨: Either/Maybeを返す
calculate :: Int -> Either CalculationError Int
calculate x
  | x < 0 = Left NegativeInput
  | otherwise = Right (x * 2)

-- 推奨: MonadThrowを使用
calculate :: MonadThrow m => Int -> m Int
calculate x
  | x < 0 = throwM NegativeInputException
  | otherwise = pure (x * 2)
```

## 文字列型

### `Text`を優先

```haskell
-- 非推奨: String (= [Char])は非効率
name :: String
name = "hello"

-- 推奨: Textを使用
name :: Text
name = "hello"
```

### 変換には`convert`を使用

```haskell
import Data.Convertible

-- 個別関数より汎用的
textToByteString :: Text -> ByteString
textToByteString = convert

stringToText :: String -> Text
stringToText = convert
```

## エラーハンドリング

### 例外には型をつける

```haskell
-- 禁止: 文字列例外
throwString "something went wrong"

-- 推奨: 型付き例外
data MyError
  = NetworkError Text
  | ParseError FilePath Int
  deriving stock (Show)
  deriving anyclass (Exception)

throwM (NetworkError "connection refused")
```

### エラーを握り潰さない

```haskell
-- 禁止: エラーを無視
result <- try someAction
case result of
  Left _ -> pure ()  -- 握り潰し
  Right v -> process v

-- 推奨: 最低限ログを出力
result <- try someAction
case result of
  Left err -> logWarn $ "Action failed: " <> display err
  Right v -> process v
```

### `IO`文脈でのEither/Maybe

```haskell
-- 非推奨: 二重にネスト
fetchUser :: IO (Either FetchError User)

-- 推奨: 例外を使用
fetchUser :: IO User  -- 失敗時は例外

-- ただしlookup操作は例外
findUser :: UserId -> IO (Maybe User)  -- 存在しないのは正常系
```

## IO抽象化

### 型クラスで抽象化

```haskell
-- 非推奨: IOを直接使用
readConfig :: IO Config

-- 推奨: 型クラスで抽象化
readConfig :: MonadIO m => m Config

-- より制約が必要な場合
processFile :: MonadUnliftIO m => FilePath -> m ()
```

### `liftIO`の冗長な使用を避ける

```haskell
-- 禁止: 既にMonadIO制約がある関数にliftIO
foo :: MonadIO m => m ()
foo = liftIO bar  -- barが既にMonadIO m => m ()なら不要

-- 推奨
foo :: MonadIO m => m ()
foo = bar
```

### `askRunInIO`の使用

`IO`の文脈で`MonadUnliftIO`アクションを実行する場合:

```haskell
example :: MonadUnliftIO m => m ()
example = do
  runInIO <- askRunInIO
  liftIO $ someIOFunction $ \callback ->
    runInIO (handleCallback callback)
```

## レコードとlens

### `makeFieldsId`の使用

```haskell
{-# LANGUAGE TemplateHaskell #-}

data Config = Config
  { host :: Text
  , port :: Int
  , timeout :: NominalDiffTime
  }

makeFieldsId ''Config

-- 生成されるアクセサ
-- host :: HasHost s Text => Lens' s Text
-- port :: HasPort s Int => Lens' s Int
-- timeout :: HasTimeout s NominalDiffTime => Lens' s NominalDiffTime
```

### フィールド名の規約

- プレフィクス不要(`_`や型名プレフィクスは使わない)
- アンダースコア禁止
- `NoFieldSelectors`拡張でshadowing問題を回避

### shadowing回避

初期化時にフィールド名と衝突する場合:

```haskell
-- 変数名に'をつける
createConfig :: Text -> Int -> Config
createConfig host' port' = Config
  { host = host'
  , port = port'
  , timeout = 30
  }
```

## 同期とリソース管理

### `threadDelay`の乱用を避ける

```haskell
-- 非推奨: 固定時間待機
threadDelay 1000000  -- 1秒待つ

-- 推奨: 同期プリミティブを使用
takeMVar resultVar

-- 推奨: retryパッケージでポーリング
retrying (exponentialBackoff 1000) checkCondition action
```

### `bracket`パターンの使用

```haskell
-- 推奨: bracketでリソース管理
withFile path ReadMode $ \handle -> do
  contents <- hGetContents handle
  process contents

-- withパターンが存在するなら使用
withAsync action $ \async -> do
  result <- wait async
  process result
```

## その他

### 関数の最後の値は捨てない

```haskell
-- 非推奨: 無意味な値の破棄
processItems :: [Item] -> IO ()
processItems items = do
  results <- mapM process items
  pure ()  -- resultsを捨てている

-- 推奨: 型を合わせる
processItems :: [Item] -> IO [Result]
processItems = mapM process
```

### exportは明示的に列挙

```haskell
-- 非推奨: 全エクスポート
module MyModule where

-- 推奨: 明示的に列挙
module MyModule
  ( MyType(..)
  , myFunction
  , HasMyField(..)
  ) where
```

ただしあまりにも多くのシンボルがある場合は仕方がないときもあります。

### mutableな変数の使用を避ける

`IORef`, `MVar`, `TVar`等はスレッド間通信など明確な理由がある場合のみ使用。
通常のデータ処理ではimmutableなデータ構造を使用する。
