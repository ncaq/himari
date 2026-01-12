## 自然言語設定

AIは日本語で出力してください。

## 重要コマンド

### `nix flake check`

対応しているフォーマット・ビルド・テストを全て実行します。

```console
nix flake check
```

例えば`nix fmt`, `cabal build`, `cabal test`も全て含まれています。

### フォーマット

基本的にファイルはツールで自動フォーマットしています。

#### nix fmt

[treefmt-nix](https://github.com/numtide/treefmt-nix)が対応しているファイルは以下のコマンドでフォーマット出来ます。

```console
nix fmt
```

Claude CodeがStopするときも自動で`nix fmt`が実行されます。

### ビルド

#### Haskell

ビルドは以下のコマンドを実行します。

```console
cabal build --disable-optimization --enable-tests
```

### テスト

テストは以下のコマンドを実行します。

```console
cabal test --disable-optimization --enable-tests
```

## 使用する技術スタックやライブラリ

実装には[Haskell](https://www.haskell.org/)をメインに使っています。

環境構築には[Nix Flakes](https://wiki.nixos.org/wiki/Flakes/ja)を利用しています。
Nix FlakesでHaskell部分を管理するには[haskell.nix](https://input-output-hk.github.io/haskell.nix/)を使っています。
Haskellのビルドに使うツールは[Cabal](https://www.haskell.org/cabal/)です。

## ディレクトリ構成

### ルートディレクトリ

#### `.hlint.yaml`

`.hlint.yaml`は他の`hlint`ディレクトリ以下のDhallファイルから自動生成しているため、
直接の読み書きは想定していません。

`.hlint.yaml`は通常のHaskellプロジェクトと異なり、
このプロジェクトのリンターというだけではなく、
他のユーザにも配るhimariライブラリのリンター設定として開発しています。

#### `CHANGELOG.md`

[Keep a Changelog](https://keepachangelog.com/en/1.1.0/)形式で変更履歴を管理しています。

このChangeLogは英語で記述してください。

行はなるべく最大120文字程度の長さまで収めてください。

編集したあとは`nix fmt`で正しく書けているかチェックしてください。

`changelog-lint`を使うには`.changelog-lint.toml`をconfigとして使う必要があるため、
簡単に実行するために`nix fmt`を使用してください。

### hlint

`.hlint.yaml`ファイルを生成するためのDhallソースコードが配置されています。

```zsh
nix run '.#generate-hlint'
```

コマンドで`.hlint.yaml`が新しく生成されます。

### src

カスタムPreludeとしてのhimariライブラリのソースコードが配置されています。

### test

動作を継続してある程度確認するためのテストコードが配置されています。

## Nix

Nix Flakesはgitで管理されていないファイルを意図的に無視します。
よって新規にソースコードなどを追加した時に`nix flake check`を通すためには、
git addで使いたいファイルを追加する必要があります。

## Haskell

### 言語設定

Haskellの言語バージョンや言語拡張はパッケージレベルで以下を設定しています。

```cabal
default-language: GHC2024
default-extensions:
  ApplicativeDo
  BlockArguments
  CPP
  DefaultSignatures
  DerivingVia
  DuplicateRecordFields
  FunctionalDependencies
  LexicalNegation
  LinearTypes
  MonadComprehensions
  MultiWayIf
  NegativeLiterals
  NoFieldSelectors
  NoImplicitPrelude
  OverloadedLabels
  OverloadedRecordDot
  OverloadedStrings
  ParallelListComp
  PatternSynonyms
  QualifiedDo
  QuantifiedConstraints
  QuasiQuotes
  RecordWildCards
  RecursiveDo
  StrictData
  TemplateHaskell
  TypeData
  TypeFamilies
  TypeFamilyDependencies
  ViewPatterns
```

### 危険な言語拡張の禁止

以下の言語拡張は危険なので使用することを禁止します。

- `AllowAmbiguousTypes`
- `ImplicitParams`
- `ImpredicativeTypes`
- `IncoherentInstances`
- `LiberalTypeSynonyms`
- `OverlappingInstances`
- `RebindableSyntax`
- `UndecidableInstances`
- `UndecidableSuperClasses`

### 危険な関数の禁止

以下の関数は危険なので使用することを絶対に禁止します。

- `unsafeDupablePerformIO`
- `unsafeFixIO`
- `unsafeInterleaveIO`
- `unsafePerformIO`

### 警告は無効にしない

警告をプラグマによって無効にすることは禁止です。
特にHaskellの警告は無効にしない。
どうしても無効にしないと書けない場合はこちらに確認をしてください。

### exportは明示的に列挙する

全てのシンボルをexportで公開するのは禁止です。

外部に公開しないといけないシンボルだけをexportしてください。

明示的に列挙することで公開しているAPIが明確になり、
デッドコードの検出なども簡単になります。

### 部分関数の禁止

純粋関数なのに例外を頻繁に投げる以下のような関数の使用は禁止です。

- `fromJust`
- `read`

例えば`read`には`readMaybe`などの安全な代替関数があるので、そちらを使ってください。

### `error`関数の禁止

純粋関数空間の中で例外を投げられる`error`関数の使用は禁止です。
よほどの理由がない限りは正当化されません。
上位空間に`MonadThrow`や`Either`などを使って例外を伝播させてください。

### 例外は型をつけよう

`throwString`のような関数を使うより、
ちゃんと例外に型をつけて`throwM`などで型がついた例外を使いましょう。

例外を表現するデータ型はなるべく`Text`などの文字列を使うのではなく、
エラーが起きた理由を表現する構造的なデータ型をフィールドとして持ってください。

### エラーを握り潰すのは禁止

`IO`の文脈などで例外が生じた場合に握りつぶして何もしないような行為は禁止。
`IO`は文脈的に既に例外が発生する可能性があることを示しているので、
例外が上位に伝播することは許容されます。
特に動作上問題がない場合は警告などのレベルのログを出しておく。
問題が発生している場合は例外を上位に再伝達する。
そこで例外を処理するのが完全に適切なら警告を出して処理する。

例外だけではなく`Either`の`Left`なども適切に処理してください。
`Left`が来るのが正常系である場合はデフォルト値やフォールバック値を使ってください。
単に握りつぶすのは禁止です。

### `IO`的な文脈で`Either`や`Maybe`を包むのは推奨されない

`IO`は例外が発生する可能性がある文脈を十分に表現しているモナドなので、
その中で`Either`や`Maybe`を使って例外的な状況を示すのは二重にネストしていて混乱を招きます。
素直に例外を投げてしまうのが良いでしょう。

`IO`的な操作をしているが`IO`そのものではないモナドの場合は、
`MonadThrow`や`MonadIO`の型クラスが役に立つ場合があります。

ただし例外があり、
データベースを`lookup`するような操作は、
存在しないというデータが正常系として扱われるので、
その場合は`IO (Maybe a)`のようなシグネチャを使うことは適切です。

### `IO`をなるべく直接使わず型クラスを使う

`IO`モナドはあまりにもプリミティブなので他のモナド変換子などと一緒に取り扱うのが不便です。
呼び出すたびに`liftIO`を使うのは冗長なため、
出来る限り`MonadIO`, `MonadUnliftIO`と言った型クラスで抽象化するべきです。

### 無駄な`liftIO`の禁止

既に`MonadIO m => m a`のような型を持っている関数を、
`liftIO`に渡しても問題なく動きますが、
冗長で読みづらいのでやめてください。

#### `IO`内部で`MonadUnliftIO`のアクションを実行する

`MonadIO`や`MonadUnliftIO`の文脈で`IO`のアクションを実行する場合は`liftIO`を使うだけで良いです。

逆に`IO`の文脈で`MonadUnliftIO`のアクションを実行する場合はひと工夫必要です。

以下の関数を使うことで解決できます。

```haskell
askRunInIO :: MonadUnliftIO m => m (m a -> IO a)
```

`askRunInIO`を`MonadUnliftIO`の文脈で呼び出すことで、
`MonadUnliftIO`のアクションを`IO`に変換する関数を取得できます。

これを使うと`IO`を要求するライブラリの型に対して`MonadUnliftIO`のアクションを少しラムダ式で包んだりすれば渡すことが出来ます。

### `String`の使用をなるべく避ける

`String`は`[Char]`のエイリアスであり、
Haskellの文字列を表現するために使われますが、
非常に非効率的であり、
さらに表示したときの日本語文字列がしばしばエスケープされます。
昔からある型のため仕方なく使われていますが、
なるべく`Text`を使ってください。

`Text`はUTF-8でエンコードされた文字列を効率的に扱うための型です。
基本的に`Text.Lazy`ではなくStrictな`Text`を使ってください。
`ByteString`との使い分けに関しては、
Unicodeで正しく表現できる文字列である場合`Text`を使い、
バイナリデータやエンコードが不明な場合は`ByteString`を使うのが正しいです。

しかし現代においてはUnicodeで表現できない文字列はあまりないので、
バッファ上のバイナリデータを使う場合などを除いては、
基本的に`Text`を使うことが適切でしょう。

`String`は古くから使われているからライブラリに蔓延しているだけのガンです。
使わなければいけない場合に一瞬`convert`などで変換するだけにしてください。

詳しく知りたい場合は、
[Haskellの文字列型：分類と特徴 #Haskell - Qiita](https://qiita.com/mod_poppo/items/740659702f31216fdade)を参照してください。

### mutableな変数の使用を避ける

Haskellに限らずmutableな変数は避けるべきだとされています。
特にHaskellは純粋関数型言語でありimmutableにレコード全体を差分更新することが前提とされて効率よく行えるようになっているので、
mutableな変数がほしいことはめったにありません。

スレッド間の通信などでトランザクションを作りたいとかのどうしても必要な理由でない場合、
mutableな変数を表す型は使わないでください。

### `threadDelay`の乱用を避ける

`threadDelay`はスレッドを指定した時間だけ遅延させる関数です。
`threadDelay`を乱用するのはやめましょう。

時間に依存するコードは安定性や移植性が低いためです。
他のマシンでは同じ時間で処理が完了しないかもしれません。

また必然的にその時間だけ実行がストップしてしまうので、
待つように命令した分だけ実行が遅くなります。

ただし以下のようにリソースを保持するために明確に意図的に永久的に停止する場合は問題ありません。

```haskell
threadDelay maxBound
```

テストコードを書く時に実行を待つ部分が実装されていない場合などは仕方ない時もあります。
しかしなるべく避けましょう。

`MVar`や`TMVar`などの同期変数を使って正確に同期するのが望ましいです。

外部のコントロールに依存する場合は、
[retry: Retry combinators for monadic actions that may fail](https://hackage.haskell.org/package/retry)
パッケージの`exponentialBackoff`を使って、
短い単位の繰り返しの待機をしてください。

### shadowing警告を回避してレコードを初期化する

データ型のフィールド名と同じ変数を定義すると、
しばしばlensのアクセサによってshadowing警告が発生します。

そのため`NamedFieldPuns`は実質使えないと考えてください。

単にフィールドを設定する場合はlensのSetterを使ってください。

初期化時などlensが使えない場合は、フィールド名に`'`をつけた変数名を使ってください。
例えば`foo`フィールドの場合`foo'`変数を定義して、最終的に以下のように代入に使います。

```haskell
{ foo = foo' }
```

### 関数の最後の値は捨てない

わざわざ関数の最後で`pure ()`や`return ()`や`void`を使って値を捨てるのは禁止です。
特に理由がないならば最後の関数の値を捨てないように型の方を合わせてください。

### bracketで書ける時はそれを使う

`bracket`を使うと例外などを考慮してリソースを確実に解放することが出来ます。
`bracket`でリソースの解放処理が書ける時はそちらを使ってください。
わざわざバラバラの`do`ブロックで書き直さないでください。

### 出来る限りwithパターンの関数を使う

`bracket`関数の特化型であるリソースの確保と解放がセットになっていて、
実行したいアクションだけを渡せる関数がしばしば存在します。

例えば、

```haskell
withAsync :: IO a -> (Async a -> IO b) -> IO b
```

などの関数です。

存在するならばそれを優先します。

### himari

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

### Template Haskellの`mkName`と`newName`の使いかた

既にスコープに存在する名前をキャプチャする形で参照したい時は`mkName`を使います。
新しいフレッシュな衝突しない名前を生成したい時は`newName`を使います。

キャプチャする必要がある場合は`mkName`、
そうでなければ安全な`newName`を使うべきです。

### [convertible: Typeclasses and instances for converting between types](https://hackage.haskell.org/package/convertible)

`convert`関数で汎用的な型変換を行っています。
`pack`, `unpack`, `encodeUtf8`, `decodeUtf8`のような個別の関数よりなるべく`convert`を使うようにしてください。

convertibleをimportするときは単に以下のように書いてください。

```haskell
import Data.Convertible
```

### [lens: Lenses, Folds and Traversals](https://hackage.haskell.org/package/lens)

#### `makeFieldsId`

`NoFieldSelectors`を前提に定義したデータ構造に対してlensのレコードのフィールドアクセサを定義する時は、
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
双方それをimportするのも手です。

#### `makeFields`

サードパーティのデータ構造や自動生成されたデータ構造に対しては、
プレフィクスやアンダースコアがあるかどうかを考慮して、
`makeFields`などの他のTemplate Haskell関数を使ってください。

#### lensで定義されたアクセサは、アクセサ単体ではなく型クラスごとexportする

例えば`makeFieldsId`で`HasUser`型クラスと`user`アクセサを定義した場合、
`user`アクセサをexportするのではなく、
`HasUser`型クラスをexportしてください。

#### なるべくlensを使う

パターンマッチを使ってレコードのフィールドにアクセスすると、
どうしてもshadowing警告が発生しやすくなります。
そのため最初からlensを使ってフィールドにアクセスしてください。

## テストや品質保証の基準

テストフレームワークには[sydtest: A modern testing framework for Haskell with good defaults and advanced testing features.](https://hackage.haskell.org/package/sydtest)を使用しています。

主要なAPIは[Test.Syd](https://hackage-content.haskell.org/package/sydtest-0.22.0.0/docs/Test-Syd.html)を参照してください。
sydtestはhspecそのものではないことに注意してください。

### モジュール名

テストする対象と同じ名前空間に置いて、
テストするモジュール名の末尾に`Spec`をつけてください。

つまりモジュール名は例えば、
`Env.Type`
なら、
`Env.TypeSpec`
となります。

### 意味のないテストは禁止

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

### Either値をテストするときは値を直接比較する

Eitherが返ってくる値`x`をテストするときは、
次のように書くのは避ける。

```haskell
isLeft x `shouldBe` True
```

このように書くとテストフレームワーク側が実際どのような値が想定外なのか分からなくてテスト失敗時に情報がなくなってしまう。
Eitherの値が`Eq`のインスタンスである場合は以下のように単純に比較できる。

```haskell
x `shouldBe` Left "expected error"
```

`Eq`のインスタンスでない場合でも`isLeft`よりは実際の中身の振る舞いを検査する関数が何かしらあるはず。
