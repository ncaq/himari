# himari

A standard library for Haskell to replace rio

## 注意

> [!IMPORTANT]
> himariはrioとは完全に同じように使えるわけではありません。
> ここで主な注意点を挙げます。

### 重大なランタイムの非互換性

#### ログの出力先の変更

rioは基本的に標準出力にログを出力しますが、
himariはデフォルトのガイドラインに従うと標準エラー出力にログを出力します。

ログは標準エラー出力に出すべきだと考えているためです。

変更したい時は出力先を`stderr`から`stdout`などに変更することで簡単に変更可能です。

### 部分関数への対処方法の違い

rioは部分関数を独自のモジュールでexportして提供していますが、
himariはそのままオリジナルのモジュールを使ってもらいます。

よってhimariは部分関数を除去していません。

なのでhimariはhlintのルールで警告を出すことで対処しています。

プロジェクトルートにある[hlint.yaml](./hlint.yaml)をあなたのプロジェクトにコピーするか、
追加してください。

## 背景

私は、
[commercialhaskell/rio: A standard library for Haskell](https://github.com/commercialhaskell/rio)
の思想が好みで長く使っています。

しかしrioの好みではない点もいくつかあります。
単純に質の問題であれば私がコントリビュートすれば良いのですが、
非互換な選択である部分が多いため、
それは受け入れられないだろうと考えて、
rioに似たライブラリであるhimariを作成することにしました。

## 目標

### 依存関係が大きくなることを恐れない

rioは依存関係を小さくしようと考えているのか、
[lens: Lenses, Folds and Traversals](https://hackage.haskell.org/package/lens)
ではなく、
[microlens: A tiny lens library with no dependencies](https://hackage.haskell.org/package/microlens)
を採用しています。

しかし実際のライブラリでは本家のlensに依存していることも多く、
結局使おうとしてコンフリクトすることが多いです。

Haskellは静的にビルドする言語なので、
依存関係が多いことはあまり怖くありません。

使うとは限らない依存関係もドシドシimportしてしまいます。

バージョンごとの依存関係の解決が大変なのはNixなどのパッケージマネージャのレイヤーで解決することにします。

### なるべく一行で済ませたい

himariは基本的には以下の一行で代替Preludeを提供することを目指します。

```haskell
import Himari
```

色々と書くのは面倒ですからね。
これで衝突しない範囲はたくさんimportしてしまいます。

同じシンボル名をexportしていて衝突してしまうものは仕方がないのでqualified importを使ってもらいます。

### なるべく独自のシンボルを定義しない

himariはrioで言う`RIO.Text`のような独自のシンボルを定義することをなるべく避けます。
LLMのコーディングエージェントに独自のシンボルを使うことを守ってもらうのが難しいからです。
しばしばオリジナルのシンボルをimportしてしまいます。
