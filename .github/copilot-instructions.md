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
Nix FlakesでHaskell部分を管理するには[haskell.nix](https://input-output-hk.github.io/haskell.nix/)を使っています。
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

# Haskell

## 言語設定

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

### GHC2024に含まれている拡張

GHC2024には以下の拡張が含まれています。

- `BangPatterns`
- `BinaryLiterals`
- `ConstrainedClassMethods`
- `ConstraintKinds`
- `DataKinds`
- `DeriveDataTypeable`
- `DeriveFoldable`
- `DeriveFunctor`
- `DeriveGeneric`
- `DeriveLift`
- `DeriveTraversable`
- `DerivingStrategies`
- `DisambiguateRecordFields`
- `DoAndIfThenElse`
- `EmptyCase`
- `EmptyDataDecls`
- `EmptyDataDeriving`
- `ExistentialQuantification`
- `ExplicitForAll`
- `ExplicitNamespaces`
- `FlexibleContexts`
- `FlexibleInstances`
- `ForeignFunctionInterface`
- `GADTSyntax`
- `GADTs`
- `GeneralisedNewtypeDeriving`
- `HexFloatLiterals`
- `ImportQualifiedPost`
- `InstanceSigs`
- `KindSignatures`
- `LambdaCase`
- `MonoLocalBinds`
- `MultiParamTypeClasses`
- `NamedFieldPuns`
- `NamedWildCards`
- `NumericUnderscores`
- `PatternGuards`
- `PolyKinds`
- `PostfixOperators`
- `RankNTypes`
- `RelaxedPolyRec`
- `RoleAnnotations`
- `ScopedTypeVariables`
- `StandaloneDeriving`
- `StandaloneKindSignatures`
- `StarIsType`
- `TraditionalRecordSyntax`
- `TupleSections`
- `TypeAbstractions`
- `TypeApplications`
- `TypeOperators`
- `TypeSynonymInstances`

### 追加で有効にしている拡張

GHC2024に加えて、以下の拡張をデフォルトで有効にしています。

#### ApplicativeDo

do記法をApplicativeに脱糖します。
独立した操作の並列実行が可能になり、
パフォーマンスが向上する場合があります。

副作用の実行順序が変わる可能性があるため、
順序に依存するコードでは注意が必要です。
ただし順序に依存する処理は`Monad`を使うべきであり、
`Applicative`で順序依存するコードは設計上の問題があるため、有効にしています。

#### BlockArguments

`when cond do`のようにブロックを直接引数に渡せます。
括弧を減らせる純粋な構文糖衣で既存コードに影響しません。

#### CPP

Cプリプロセッサを有効にします。
GHCバージョン分岐などライブラリ開発で必要になります。
行頭の`#`がディレクティブとして解釈されますが通常問題になりません。

#### DefaultSignatures

型クラスのデフォルト実装にジェネリクスを使えます。
ボイラープレートを減らせ既存コードに影響しません。

#### DerivingVia

別の型経由でインスタンスを導出できます。
明示的に使用するため安全で`newtype`パターンで特に有用です。

#### DuplicateRecordFields

異なる型で同名フィールドを許可します。
`NoFieldSelectors`と組み合わせて使用することでフィールド名の衝突を避けられます。

#### FunctionalDependencies

型クラスパラメータ間の関数従属性を指定できます。
型推論を助け`TypeFamilies`の代替として使えます。

#### LexicalNegation

`-`の字句解析を改善し、`f -1`が`f (-1)`として解釈されます。
既存の`f - 1`(減算)の構文を壊しますが、
より自然な解釈になります。

減算では双方にスペースを入れたほうが良いのでそちらの構文を推奨します。

#### LinearTypes

線形型(`a %1 -> b`)の構文が使えます。
新しい構文が追加されるだけで既存コードには影響しません。
ライブラリが線形型を使っている場合に型シグネチャを読めるようになります。

#### MonadComprehensions

リスト内包表記をモナドに一般化します。
純粋な構文拡張で既存のリスト内包表記も動作します。

#### MultiWayIf

`if | cond1 -> ... | cond2 -> ...`形式のガード風ifが書けます。
純粋な構文糖衣で害はありません。

#### NegativeLiterals

`-1`を`negate 1`ではなくリテラルとして扱います。
オーバーフロー防止に便利で、
既存コードへの影響は軽微です。

#### NoFieldSelectors

フィールドセレクタ関数を生成しません。
`DuplicateRecordFields`や`OverloadedRecordDot`と組み合わせて、
名前空間の汚染を防ぎます。

これは非常に破壊的な言語拡張ですが、
Haskellの同名フィールドを定義しづらいという問題を解決してくれる極めて重要な拡張機能のため、
himariの強い方針としてデフォルト有効にしています。

フィールドにはlensか`OverloadedRecordDot`かパターンマッチでアクセスできます。

#### NoImplicitPrelude

標準Preludeを自動インポートしません。
カスタムPreludeライブラリであるhimariを使用するので自然な拡張です。

#### OverloadedLabels

`#label`記法が使えます。
optics系ライブラリで有用で純粋な構文追加です。

#### OverloadedRecordDot

`person.name`記法でフィールドにアクセスできます。
`NoFieldSelectors`と組み合わせて現代的なレコード操作を可能にします。

#### OverloadedStrings

文字列リテラルから`Text`や`ByteString`を直接作れます。
`String`を避けて`Text`を使う方針だと便利です。
たまに型注釈が必要になる程度の影響です。

#### ParallelListComp

並列リスト内包表記`[x + y | x <- xs | y <- ys]`が書けます。
純粋な構文拡張で害はありません。

#### PatternSynonyms

パターンを抽象化できます。
ライブラリ経由で使うことがあり、
明示的に使用するため安全です。

#### QualifiedDo

`Module.do`で独自のdo記法を使えます。
明示的に使用するため既存コードに影響しません。

#### QuantifiedConstraints

`forall a. C a => ...`のような量化された制約が書けます。
高度な型レベルプログラミングで有用で既存コードに影響しません。

#### QuasiQuotes

準クォート`[quasi|...|]`が使えます。
Template Haskellと組み合わせて使用し、
明示的に使用するため安全です。

#### RecordWildCards

`Foo{..}`でフィールドを一括展開できます。
外部ライブラリとの連携で便利な場面があります。
`NoFieldSelectors`環境では内部で使いにくいですが、
有効にしておいてもあまり害はありません。

#### RecursiveDo

`mdo`や`rec`で再帰的束縛ができます。
明示的に使用しない限り有効にならず、
無限再帰は拡張なしでも起こり得るため、
デフォルト有効でも危険ではありません。

#### StrictData

データ型のフィールドをデフォルトで正格評価にします。
遅延評価を前提としたフィールド(無限リストなど)は注意が必要ですが、
通常のアプリケーションのフィールドでは正格評価が適切です。
`Strict`(全体を正格化)より影響範囲が限定的で安全です。

これは破壊的な言語拡張ですが、
モダンなHaskellでは通常フィールドレベルでは正格評価をするので、
himariの方針としてデフォルト有効にしています。

#### TemplateHaskell

メタプログラミングが使えます。
コンパイル時間が増加する可能性がありますが、
あまり害はありません。

#### TypeData

型レベル専用のデータ型を定義できます。
プロモーションの`'`プレフィックスが不要になり意図が明確になります。
純粋な追加機能で害はありません。

#### TypeFamilies

型族(型レベル関数)が使えます。
型レベルプログラミングの基盤で、
多くのライブラリで必要です。
`MonoLocalBinds`が暗黙的に有効になりますが、
GHC2024で既に有効です。

#### TypeFamilyDependencies

型族の単射性アノテーションを指定できます。
`TypeFamilies`を使うなら型推論を助けるために便利です。

#### ViewPatterns

`f (view -> pattern) = ...`形式でパターンマッチ時に関数を適用できます。
純粋な構文糖衣で害はありません。

### 有効にしなかった拡張

以下の拡張は検討の結果、デフォルトでは有効にしないことにしました。

#### Arrows

Arrow記法(`proc`構文)が使えます。
FRPなどで有用ですが、
typed-processの`proc`関数と名前が衝突するため有効にしていません。
`proc`がキーワードになると`proc`という名前の関数が使えなくなります。

必要な場合はファイル単位かユーザのプロジェクトで有効にしてください。
その場合はhlintのルールをカスタムする必要があります。

#### DeriveAnyClass

空のインスタンスを導出できます。
`DeriveGeneric`と`GeneralizedNewtypeDeriving`が両方有効だと、
どちらの戦略で導出するか曖昧になり意図しない動作になることがあります。
GHC2024で`DerivingStrategies`が有効になっているので、
必要な場合は`deriving anyclass`と明示的に書いてください。

#### OverloadedLists

リストリテラルから`Vector`等を作れます。
`IsList`制約が伝播して型推論が複雑になることがあり、
`OverloadedStrings`より面倒になることが多いため有効にしていません。

#### OverloadedRecordUpdate

`OverloadedRecordDot`と組み合わせて、
ネストされたレコード更新に`.`記法が使えます(例: `c{owner.name = "Walter"}`)。
現時点では`RebindableSyntax`が必須であり、
`RebindableSyntax`は標準のdo記法やif-then-elseの意味を変えてしまう危険な拡張です。
また`getField`と`setField`を自分で定義する必要があり実験的な段階です。
将来GHCに`setField`がビルトインされれば実用的になりますが、
現時点では使用不可です。
ネストされたレコードの更新にはlensかネストしたレコード更新構文を使ってください。

#### Strict

モジュール全体をデフォルトで正格評価にします。
`StrictData`(フィールドのみ正格化)より影響範囲が広く、
遅延評価を前提としたコード(無限リストなど)が壊れます。
また遅延評価を前提とする`where`句が無駄に評価されることもあります。
正格評価が必要な場合は`BangPatterns`で明示的に指定するか、
ファイル単位で言語拡張を有効にしてください。

#### UnicodeSyntax

`∀`や`→`などのUnicode記号が使えます。
fourmoluとの相性が悪く意図しない変換が発生することがあるため有効にしていません。

### 非推奨の言語拡張

以下の言語拡張は動作が不安定になりがちですが、
ライブラリを使用する時など必要になる場面があるため、
最終手段として使用を許可します。

#### ImplicitParams

暗黙パラメータを使用できます。
`?cmp`のような形式で動的スコーピングと静的型付けを組み合わせた機能を提供します。

```haskell
sort :: (?cmp :: a -> a -> Bool) => [a] -> [a]
main = let ?cmp = (<=) in sort [3,1,2]
```

##### 問題点

コヒーレンス(一貫性)の欠如が最大の問題です。
型署名の有無でプログラムの動作が変わるという、
Haskellの基本的な期待を破る現象が起きます。

```haskell
-- 型署名なし: 結果は(123, 123)
result = let ?myparam = 456 in ?myparam
terror = let ?myparam = 123 in (result, result)

-- 型署名あり: 結果は(123, 456)
result :: (?myparam :: Int) => Int
result = let ?myparam = 456 in ?myparam
horror = let ?myparam = 123 in (result, result)
```

また暗黙的な振る舞いがデバッグを困難にし、型推論との相性も悪いです。

##### 代替手段

- `ReaderT`モナド
- `Has`型クラスとlensの組み合わせ
- 明示的なパラメータ渡し

##### 使わざるを得ない場面

GHCの`HasCallStack`は内部実装として`ImplicitParams`を使用しています。
`HasCallStack`を使うライブラリとの連携で必要になる場合があります。

#### UndecidableInstances

GHCがインスタンス宣言に課すPaterson ConditionやCoverage Conditionを緩和します。
これらの条件は型チェッカーが有限時間で終了することを保証するためのものです。

##### 問題点

型チェッカーの無限ループを引き起こす可能性があります。
以下のような循環的なインスタンスが許可されてしまいます。

```haskell
class Bar a => Foo a
instance Bar a => Foo a
instance Foo a => Bar a
```

また重複インスタンスの隠蔽に悪用される危険があります。

##### 安全性メカニズム

GHCはデフォルトで型チェッカーの深さ制限を設けており、
無限ループは検出されてエラーになります。

##### 使わざるを得ない場面

mtl、lens、servantなど多くの主要ライブラリで使用されています。
モナド変換子に対する型クラスインスタンス(例: `MonadState s m => MonadState s (ReaderT r m)`)は、
Coverage Conditionを満たさないため`UndecidableInstances`が必要です。

##### 安全に使うためのガイドライン

1. 重複インスタンスを書いていないか確認する
2. 循環定義を避ける
3. 型ファミリが無限に展開される可能性がないか検討する
4. GHCが拡張の有効化を提案した場合その理由を理解する

### 危険な言語拡張の禁止

以下の言語拡張は危険なので使用することを禁止します。

#### AllowAmbiguousTypes

型シグネチャの曖昧性チェックを無効化します。

##### 問題点

モジュール全体で曖昧性チェックを無効化するため、
意図しない定義も通過させてしまいます。

GHCは「AllowAmbiguousTypesを有効にする」と提案しますが、
これは問題を使用サイトに先送りするだけで診断がより困難になります。

初心者を騙して、
実際の間違いからはるかに離れた呼び出しサイトにエラーメッセージを先送りさせる悪名高い拡張です。

```haskell
class Collects c e where
  empty :: c  -- eが曖昧
```

型安全性自体は損なわれませんが、
エラーが定義サイトではなく使用サイトで報告されるようになります。

#### DeferTypeErrors

型エラーを実行時まで遅延させます。

##### 問題点

コンパイル時の型チェックというHaskellの最大の安全保証を無効化します。
型エラーが実行時例外として現れ予期しないクラッシュの原因になります。
問題が実際に発生する場所から遠く離れた場所で失敗しデバッグが困難になります。

開発中に部分的に書かれたコードをテストする際に使用されることがありますが、
本番コードでは絶対に使用しないでください。

#### ExtendedDefaultRules

より多くの型クラスに対してデフォルトルールを適用します。
GHCiではデフォルトで有効になっています。

##### 問題点

不適切な型デフォルトが発生します。

例えば`show.read`が`String -> String`型と判断されますが、
`()`にデフォルトされるため意味のある動作をしません。

通常のコードではデフォルトを増やすのではなく減らしたいため不適切です。

GHCiでの対話的な使用では便利ですが、
ソースコードには記述しないでください。

#### ImpredicativeTypes

型の任意の場所で全称量化子を許可します(例: `Maybe (forall a. [a] -> [a])`)。

##### 問題点

長年「半壊れた状態」で公式にはサポートされていませんでした。
今コンパイルできるコードが将来も型チェックできる保証がありません。

Haskellの型推論と非常に相性が悪く完全な型シグネチャの指定が必要になることが多いです。

GHC 9.x以降はQuick Look推論アルゴリズムにより改善されましたが、
型クラス制約とは完全には機能しません。

#### IncoherentInstances

複数のマッチするインスタンスがあり、
どれも最も特殊でない場合、
GHCが任意に1つを選択することを許可します。

##### 問題点

インスタンス選択が非決定的になります。
インスタンス選択がコンパイル順序に依存する可能性があります。
関連データや型を含む型クラスでのオーバーラップは「セグメンテーションフォルトレベルで不健全」です。

GHC 7.10以降は非推奨であり、
代わりに`INCOHERENT`プラグマを使用します。
ただし`INCOHERENT`プラグマも使用しないでください。

#### LiberalTypeSynonyms

型シノニムを展開した後にのみ型の妥当性チェックを行います。

##### 問題点

`DataKinds`と`PolyKinds`との組み合わせでCore Lintエラー(内部エラー)が発生することがあります。
型シノニムの展開により予期しない型エラーが発生する可能性があります。

型シノニム内で`forall`を使用したり、
部分適用したりするとGHCが提案してきます。

#### OverlappingInstances

型クラスインスタンスのオーバーラップを許可します。

##### 問題点

型クラスのコヒーレンス(一貫性)を破壊します。
インスタンスを追加すると静かに後方互換性が壊れます。
`UndecidableInstances`との組み合わせが特に危険です。

GHC 7.10以降は非推奨であり、
代わりに`OVERLAPPABLE`/`OVERLAPPING`プラグマを使用します。
ただしこれらのプラグマも使用しないでください。

#### RebindableSyntax

do記法、
if-then-else、
数値リテラルなどの標準構文の意味を再定義できます。

##### 問題点

実験的な機能であり通常よりチェックが少ないです。

`LinearTypes`との非互換性があり線形文脈でif式が使えなくなります。

`ifThenElse`は正しくオーバーロードできません。
実際の`ifThenElse`には通常の関数にはない特殊な振る舞いがあります。

`deriving`との相性が悪く、導出されたコードには適用されないため型エラーが発生する可能性があります。

`Template Haskell`との互換性の問題があります。

カスタムPreludeやDSL実装で使用されることがありますが、
代わりに`QualifiedDo`拡張がdo記法のみの再束縛としてより限定的で安全です。

#### UndecidableSuperClasses

型クラスのスーパークラス制約に対する保守的なチェックを緩和し、
再帰的なスーパークラスを許可します。

##### 問題点

循環的な定義を許可してしまい、
型チェッカーが停止しない可能性があります。

GHCバージョン間で回帰が報告されており、
あるバージョンで通ったコードが別のバージョンで拒否されることがあります。

スタックオーバーフローやメモリ不足の原因になることがあります。

`AllowAmbiguousTypes`との相互作用で問題が発生することがあります。

型族や型変数を含むスーパークラス制約を定義しようとするとGHCが提案してきます。

## 危険な関数の禁止

以下の関数は危険なので使用することを禁止します。

- `unsafeDupablePerformIO`
- `unsafeFixIO`
- `unsafeInterleaveIO`
- `unsafePerformIO`

## GHCの警告は無効にしない

警告をプラグマによって無効にすることは原則禁止します。

ただし孤立インスタンスを仕方なく定義する場合は、

```haskell
{-# OPTIONS_GHC -Wno-orphans #-}
```

は最終手段として許可します。

またTemplate Haskellを利用したコード生成で変数名のshadowingが発生する場合や、
未使用変数が発生する場合も仕方なく無効にすることを許可します。

```haskell
{-# OPTIONS_GHC -Wno-shadowed-variables #-}
{-# OPTIONS_GHC -Wno-unused-binds #-}
```

## hlintの警告は無効にしない

hlintの警告を無効にすることは原則禁止します。

ただしどうしてもその方法じゃないと書けなかったり、
著しくパフォーマンスの低下を招く場合は仕方なく無効にすることを許可します。

その場合でもなるべく局所的に無効にしてください。
全体で無効にするのは禁止です。

## exportは明示的に列挙する

exportで全てのシンボルを公開するのは原則禁止です。

外部に公開しないといけないシンボルだけをexportしてください。

結果的に全てexportすることになっても、
明示的に列挙してください。

明示的に列挙することで公開しているAPIが明確になり、
デッドコードの検出なども簡単になります。

ただしTemplate Haskellでシンボルを大量に生成する場合で、
全部把握して列挙するのが困難な場合は全てexportすることを許可します。

## 部分関数の禁止

純粋関数なのに例外を頻繁に投げる以下のような関数の使用は禁止です。

- `fromJust`
- `read`

例えば`read`には`readMaybe`や`readMay`などの安全な代替関数があるので、
そちらを使ってください。

## `error`関数の禁止

純粋関数空間の中で例外を投げられる`error`関数の使用は禁止です。
よほどの理由がない限りは正当化されません。
上位空間に`MonadThrow`や`Either`などを使って例外を伝播させてください。

## 例外は型をつけよう

`throwString`のような関数を使うより、
ちゃんと例外に型をつけて`throwM`などで型がついた例外を使いましょう。

例外を表現するデータ型はなるべく`Text`などの文字列を使うのではなく、
エラーが起きた理由を表現する構造的なデータ型をフィールドとして持ってください。

## エラーを握り潰すのは禁止

`IO`の文脈などで例外が生じた場合に握りつぶして何もしないような行為は禁止です。
`IO`は文脈的に既に例外が発生する可能性があることを示しているので、
例外が上位に伝播することは許容されます。

例外が生じても問題がないケースはそのことをコメントなどで明示的に示してください。

問題が発生している場合は例外を上位に再伝達します。
そこで例外を処理するのが完全に適切ならwarnかerrorレベルのログを出して処理します。

例外だけではなく`Either`の`Left`なども適切に処理してください。
`Left`が来るのが正常系である場合はデフォルト値やフォールバック値を使ってください。
単に握りつぶすのは禁止です。

## `IO`的な文脈で`Either`や`Maybe`を包むのは推奨されない

`IO`は例外が発生する可能性がある文脈を十分に表現しているモナドなので、
その中で`Either`や`Maybe`を使って例外的な状況を示すのは二重にネストしていて混乱を招きます。
素直に例外を投げてしまうのが良いでしょう。

`IO`的な操作をしているが`IO`そのものではないモナドの場合は、
`MonadThrow`や`MonadIO`の型クラスが役に立つ場合があります。

ただし例外があり、
データベースを`lookup`するような操作は、
存在しないというデータが正常系として扱われるので、
その場合は`IO (Maybe a)`のようなシグネチャを使うことは適切です。

## `IO`をなるべく直接使わず型クラスを使う

`IO`モナドはあまりにもプリミティブなので他のモナド変換子などと一緒に取り扱うのが不便です。
呼び出すたびに`liftIO`を使うのは冗長なため、
出来る限り`MonadIO`, `MonadUnliftIO`といった型クラスで抽象化するべきです。

## 無駄な`liftIO`の禁止

既に`MonadIO m => m a`のような型を持っている関数を、
`liftIO`に渡しても問題なく動きますが、
冗長で読みづらいのでやめてください。

## `IO`内部で`MonadUnliftIO`のアクションを実行する

`MonadIO`や`MonadUnliftIO`の文脈で`IO`のアクションを実行する場合は`liftIO`を使うだけで良いです。

逆に`IO`の文脈で`MonadUnliftIO`のアクションを実行する場合はひと工夫必要です。

以下の関数を使うことで解決できます。

```haskell
askRunInIO :: MonadUnliftIO m => m (m a -> IO a)
```

`askRunInIO`を`MonadUnliftIO`の文脈で呼び出すことで、
`MonadUnliftIO`のアクションを`IO`に変換する関数を取得できます。

これを使うと`IO`を要求するライブラリの型に対して`MonadUnliftIO`のアクションを少しラムダ式で包んだりすれば渡すことが出来ます。

## `String`の使用をなるべく避ける

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
[Haskellの文字列型：分類と特徴 - Qiita](https://qiita.com/mod_poppo/items/740659702f31216fdade)を参照してください。

## mutableな変数の使用を避ける

Haskellに限らずmutableな変数は避けるべきだとされています。
特にHaskellは純粋関数型言語でありimmutableにレコード全体を差分更新することが前提とされて効率よく行えるようになっているので、
mutableな変数がほしいことはめったにありません。

スレッド間の通信などでトランザクションを作りたいとかのどうしても必要な理由でない場合、
mutableな変数を表す型は使わないでください。

## `threadDelay`の乱用を避ける

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

## shadowing警告を回避してレコードを初期化する

データ型のフィールド名と同じ変数を定義すると、
しばしばlensのアクセサによってshadowing警告が発生します。

そのため`NamedFieldPuns`は実質使えないと考えてください。

単にフィールドを設定する場合はlensのSetterを使ってください。

初期化時などlensが使えない場合は、フィールド名に`'`をつけた変数名を使ってください。
例えば`foo`フィールドの場合`foo'`変数を定義して、最終的に以下のように代入に使います。

```haskell
{ foo = foo' }
```

## 関数の最後の値は捨てない

わざわざ関数の最後で`pure ()`や`return ()`や`void`を使って値を捨てるのは禁止です。
特に理由がないならば最後の関数の値を捨てないように型の方を合わせてください。

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
双方それをimportするのが良いでしょう。

### `makeFields`

サードパーティのデータ構造や自動生成されたデータ構造に対しては、
プレフィクスやアンダースコアがあるかどうかを考慮して、
`makeFields`などの他のTemplate Haskell関数を使ってください。

### lensで定義されたアクセサは、アクセサ単体ではなく型クラスごとexportする

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

このhimariプロジェクトのテストフレームワークには[sydtest: A modern testing framework for Haskell with good defaults and advanced testing features.](https://hackage.haskell.org/package/sydtest)を使用しています。

主要なAPIは[Test.Syd](https://hackage-content.haskell.org/package/sydtest-0.22.0.0/docs/Test-Syd.html)を参照してください。
sydtestはhspecそのものではないことに注意してください。

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

このように書くとテストフレームワーク側が実際どのような値が想定外なのか分からなくてテスト失敗時に情報がなくなってしまう。
Eitherの値が`Eq`のインスタンスである場合は以下のように単純に比較できる。

```haskell
x `shouldBe` Left "expected error"
```

`Eq`のインスタンスでない場合でも`isLeft`よりは実際の中身の振る舞いを検査する関数が何かしらあるはず。
