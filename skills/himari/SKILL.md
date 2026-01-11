---
name: himari
description: |
  HimariカスタムPreludeを使用したHaskellプロジェクトの開発支援。
  Himariモジュールのimport方法、lensアクセサ生成(makeFieldsId)、
  convertibleによる型変換、MonadUnliftIOの活用、
  エラーハンドリングのベストプラクティスをガイドします。
  Haskell、カスタムPrelude、lens、rio代替を扱う際に適用されます。
---

# Himari Haskell Development Guide

HimariはrioライブラリのシンプルなカスタムPrelude代替です。

## Preludeのimport

```haskell
import Himari
```

## 言語設定

パッケージレベルで以下を設定済み:

```cabal
default-language: GHC2024
default-extensions:
  NoImplicitPrelude
```

追加の言語拡張はモジュールレベルで個別に設定。

## 禁止事項

### 危険な言語拡張

- `AllowAmbiguousTypes`
- `ImplicitParams`
- `IncoherentInstances`
- `OverlappingInstances`
- `UndecidableInstances`
- `UndecidableSuperClasses`

### 危険な関数

- `error` - 純粋関数空間での例外は禁止
- `fromJust` - 部分関数
- `read` - 部分関数、代わりに`readMaybe`を使用
- `unsafePerformIO`系全般

## 型変換

`convert`関数で汎用的な型変換を行う:

```haskell
import Data.Convertible

-- pack/unpack/encodeUtf8/decodeUtf8より優先
text :: Text
text = convert someString
```

## 文字列型

`String`より`Text`を優先。`String`は非効率で日本語がエスケープされる。

## lensアクセサ

`NoFieldSelectors`拡張を前提に`makeFieldsId`を使用:

```haskell
data User = User
  { name :: Text
  , email :: Text
  }

makeFieldsId ''User
-- フィールドにプレフィクスやアンダースコアは不要
```

既存の型クラスがあれば自動的にインスタンスとして定義される。

## エラーハンドリング

- 例外には型をつけて`throwM`で投げる
- `throwString`より構造的なエラー型を定義
- `IO`文脈では`Either`/`Maybe`でのラップは非推奨、素直に例外を使用
- エラーを握り潰すのは禁止、最低限警告ログを出力

## IO抽象化

`IO`を直接使わず型クラスで抽象化:

```haskell
-- 良い例
foo :: MonadIO m => m ()

-- 悪い例
foo :: IO ()
```

`IO`内で`MonadUnliftIO`アクションを実行する場合は`askRunInIO`を使用。

## 詳細ドキュメント

- [coding-style.md](./coding-style.md) - 詳細なコーディング規約
- [examples.md](./examples.md) - 具体的な使用例
