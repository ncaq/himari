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

## shadowing警告を回避してレコードを初期化する

データ型のフィールド名と同じ変数を定義すると、
しばしばlensのアクセサによってshadowing警告が発生します。

そのため`NamedFieldPuns`は実質使えないと考えてください。

単にフィールドを設定する場合はlensのSetterを使ってください。

初期化時などlensが使えない場合は、
フィールド名に`'`をつけた変数名を使ってください。
例えば`foo`フィールドの場合`foo'`変数を定義して、
最終的に以下のように代入に使います。

```haskell
{ foo = foo' }
```

## bracketで書ける時はそれを使う

`bracket`を使うと例外などを考慮してリソースを確実に解放することが出来ます。
`bracket`でリソースの解放処理が書ける時はそちらを使ってください。
わざわざバラバラの`do`ブロックで書き直さないでください。

## 出来る限りwithパターンの関数を使う

`bracket`関数の特化型であるリソースの確保と解放がセットになっていて、
実行したいアクションだけを渡せる関数がしばしば存在します。

例えば、

```haskell
withAsync :: IO a -> (Async a -> IO b) -> IO b
```

などの関数です。

存在するならばそれを優先します。

## Template Haskellの`mkName`と`newName`の使いかた

既にスコープに存在する名前をキャプチャする形で参照したい時は`mkName`を使います。
新しいフレッシュな衝突しない名前を生成したい時は`newName`を使います。

キャプチャする必要がある場合は`mkName`、
そうでなければ安全な`newName`を使うべきです。

## [convertible: Typeclasses and instances for converting between types](https://hackage.haskell.org/package/convertible)

`convert`関数で汎用的な型変換を行っています。
`pack`, `unpack`, `encodeUtf8`, `decodeUtf8`のような個別の関数よりなるべく`convert`を使うようにしてください。

## [lens: Lenses, Folds and Traversals](https://hackage.haskell.org/package/lens)

### `makeFieldsId`

`NoFieldSelectors`を前提に定義したデータ構造に対して、
lensのレコードのフィールドアクセサを定義する時は、
`makeFieldsId`というTemplate Haskell関数を使ってください。

`makeFieldsId`を使うときはフィールドにプレフィクスやアンダースコアは付けないでください。
`NoFieldSelectors`拡張の力でプレフィクスは不要になっています。
`makeFieldsId`関数は完全にフィールド名と同じアクセサを生成するので、
プレフィクスやアンダースコアをつけると奇妙なアクセサが生成されてしまうのでむしろよくありません。
フィールド名にアンダースコアを使うのは禁止。

`makeFieldsId`は実行する段階で既に型クラスの定義が見えているならば、
型クラスの重複定義はせず既に存在する型クラスのインスタンスとしてアクセサを定義します。

そのため型クラスの重複を怖がってimportを少なくする必要はありません。
むしろ積極的に既存の型クラスをimportしてください。
循環参照などが発生した場合は型クラスの定義だけを別のモジュールに分割して、
双方それをimportするのが良いでしょう。

### `makeFields`

サードパーティのデータ構造や自動生成されたデータ構造に対しては、
プレフィクスやアンダースコアがあるかどうかを考慮して、
`makeFields`などの他のTemplate Haskell関数を使ってください。

### lensで定義されたアクセサはアクセサ単体ではなく型クラスごとexportする

例えば`makeFieldsId`で`HasUser`型クラスと`user`アクセサを定義した場合、
`user`アクセサをexportするのではなく、
`HasUser`型クラスを内部のアクセサも含めてexportしてください。

### なるべくlensか`OverloadedRecordDot`を使う

パターンマッチを使ってレコードのフィールドにアクセスすると、
どうしてもshadowing警告が発生しやすくなります。
そのためlensか`OverloadedRecordDot`を使ってフィールドにアクセスしてください。

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
