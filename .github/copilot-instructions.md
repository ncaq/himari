# 出力設定

## 言語

AIは人間に話すときは日本語を使ってください。

しかし既存のコードのコメントなどが日本語ではない場合は、
コメント等は既存の言語に合わせてください。

## 記号

ASCIIに対応する全角形(Fullwidth Forms)は使用禁止。

具体的には以下のような文字は右のように変換してください:

- 全角括弧 `（）` → 半角 `()`
- 全角コロン `：` → 半角 `:`
- 全角カンマ `，` → 半角 `,`
- 全角数字 `０-９` → 半角 `0-9`

# 使用する技術スタックやライブラリ

実装には[Haskell](https://www.haskell.org/)をメインに使っています。

環境構築には[Nix Flakes](https://wiki.nixos.org/wiki/Flakes/ja)を利用しています。
Nix FlakesでHaskell部分を管理するには、
[haskell.nix](https://input-output-hk.github.io/haskell.nix/)を使っています。
Haskellのビルドに使うツールは[Cabal](https://www.haskell.org/cabal/)です。

# 重要コマンド

## フォーマット

nix fmtでフォーマットとリントを実行できます。

```console
nix fmt
```

[nix-tasuke](https://github.com/ncaq/konoka/tree/master/plugins/nix-tasuke)プラグインにより、
Claudeの応答完了時にStopフックで`nix fmt`が自動実行されます。
ファイルの差分が出ることがあります。

## 統合チェック

対応しているフォーマット・ビルド・テストを全て実行します。

```console
nix flake check
```

例えば`nix fmt`, `cabal build`, `cabal test`も全て含まれています。

## ビルド

ビルドは以下のコマンドを実行します。

```console
cabal build --disable-optimization --enable-tests
```

## テスト

テストは以下のコマンドを実行します。

```console
cabal test --disable-optimization --enable-tests
```

# ディレクトリ構成

## ルートディレクトリ

### `.hlint.yaml`

`.hlint.yaml`は他の`hlint`ディレクトリ以下のDhallファイルから自動生成しているため、
直接の読み書きは想定していません。

`.hlint.yaml`は通常のHaskellプロジェクトと異なり、
このプロジェクトのリンターというだけではなく、
他のユーザにも配るhimariライブラリのリンター設定として開発しています。

### `CHANGELOG.md`

[Keep a Changelog](https://keepachangelog.com/en/1.1.0/)形式で変更履歴を管理しています。

このChangeLogは英語で記述してください。

行は最大100文字の長さまで収めてください。

編集したあとは`nix fmt`で正しく書けているかチェックしてください。

`changelog-lint`を使うには`.changelog-lint.toml`をconfigとして使う必要があるため、
簡単に実行するために`nix fmt`を使用してください。

## hlint

`.hlint.yaml`ファイルを生成するためのDhallソースコードが配置されています。

```zsh
nix run '.#generate-hlint'
```

コマンドで`.hlint.yaml`が新しく生成されます。

## src

カスタムPreludeとしてのhimariライブラリのソースコードが配置されています。

## test

動作を継続的にある程度確認するためのテストコードが配置されています。

# Nix

Nix Flakesはgitで管理されていないファイルを意図的に無視します。
よって新規にソースコードなどを追加した時に`nix flake check`を通すためには、
Gitにステージングする必要があります。
以下のコマンドでステージングだけを行ってください。
単純に`git add`するのに比べて差分をあまり壊さなくて済みます。

```zsh
git ls-files --others --exclude-standard -z | git add --intent-to-add --pathspec-from-file=- --pathspec-file-nul
```

## [convertible: Typeclasses and instances for converting between types](https://hackage.haskell.org/package/convertible)

`convert`関数で汎用的な型変換を行っています。
`pack`, `unpack`, `encodeUtf8`, `decodeUtf8`のような個別の関数よりなるべく`convert`を使うようにしてください。

## himari

このhimariプロジェクトはrioに変わるカスタムPreludeライブラリを提供することを目的としています。
このプロジェクト自身でもhimariライブラリを使えます。

```haskell
import Himari
```

ただし`Himari`モジュール自身がimportしているモジュールは循環参照の問題のためimport出来ません。

`Himari.Prelude`は外部モジュールしかimportしていないので、
循環参照の問題がある場合は以下のようにしてください。

```haskell
import Himari.Prelude
```

外部のプロジェクトで`Himari.Prelude`をわざわざimportする必要はないはずです。
`Himari`を直接importしてください。

# このプロジェクトのテストや品質保証の基準

このhimariプロジェクトのテストフレームワークには、
[sydtest: A modern testing framework for Haskell with good defaults and advanced testing features.](https://hackage.haskell.org/package/sydtest)
を使用しています。

主要なAPIは
[Test.Syd](https://hackage-content.haskell.org/package/sydtest-0.22.0.0/docs/Test-Syd.html)
を参照してください。
sydtestはhspecにAPIを寄せていますが、
あくまで違うライブラリであることに注意してください。

## モジュール名

モジュール名に悩んだときは、
テストする対象と同じ名前空間に置いて、
テストするモジュール名の末尾に`Spec`をつけてください。

つまりモジュール名は例えば、
`Env.Type`
なら、
`Env.TypeSpec`
となります。

## 意味のないテストは禁止

以下のような絶対に成功するのが自明なテストでコンパイラと人間を騙そうとするのは禁止。

```haskell
it "Dummy Test" $ do
  True `shouldBe` True
```

```haskell
it "Work Test" $ do
  expect `shouldBe` expect
```

テストが書けないときは書けないと報告する。
無意味なテストは禁止。

## Either値をテストするときは値を直接比較する

Eitherが返ってくる値`x`をテストするときは、
次のように書くのは避ける。

```haskell
isLeft x `shouldBe` True
```

このように書くとテストフレームワーク側が実際どのような値が想定外なのか分からなくて、
テスト失敗時に情報がなくなってしまいます。
Eitherの値が`Eq`のインスタンスである場合は以下のように単純に比較できる。

```haskell
x `shouldBe` Left "expected error"
```

`Eq`のインスタンスでない場合でも、
`isLeft`よりは実際の中身の振る舞いを検査する関数が何かしらあるはずです。
