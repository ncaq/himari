# Himari Usage Examples

## リソース管理

### bracketパターン

```haskell
module MyApp.Database
  ( withConnection
  , runQuery
  ) where

import Himari

withConnection :: MonadUnliftIO m => ConnectionString -> (Connection -> m a) -> m a
withConnection connStr action =
  bracket
    (liftIO $ connect connStr)
    (liftIO . close)
    action

runQuery :: MonadUnliftIO m => ConnectionString -> Query -> m [Row]
runQuery connStr query =
  withConnection connStr $ \conn ->
    liftIO $ execute conn query
```

### withパターンの組み合わせ

```haskell
module MyApp.Concurrent
  ( processInParallel
  ) where

import Himari

processInParallel :: MonadUnliftIO m => [Item] -> m [Result]
processInParallel items =
  withTaskGroup 4 $ \group -> do
    asyncs <- forM items $ \item ->
      async group (processItem item)
    mapM wait asyncs
```
