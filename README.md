# himari

[![CI](https://github.com/ncaq/himari/actions/workflows/check.yml/badge.svg)](https://github.com/ncaq/himari/actions/workflows/check.yml)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](https://github.com/ncaq/himari/blob/master/LICENSE)

[![Haskell](https://img.shields.io/badge/language-Haskell-5D4F85.svg)](https://www.haskell.org/)
[![Hackage](https://img.shields.io/hackage/v/himari.svg?logo=haskell)](https://hackage.haskell.org/package/himari)
[![Haddock](https://img.shields.io/badge/docs-Haddock-purple.svg)](https://hackage.haskell.org/package/himari/docs/Himari.html)

![Linux](https://img.shields.io/badge/linux-x86__64%20|%20ARM64-brightgreen?logo=linux&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-ARM64-brightgreen?logo=apple&logoColor=white)
![Windows](https://img.shields.io/badge/windows-x86__64-brightgreen?logo=windows&logoColor=white)

A standard library for Haskell to replace rio

このプロジェクトは、
[commercialhaskell/rio: A standard library for Haskell](https://github.com/commercialhaskell/rio)
の思想を踏襲しつつ、
よりスムーズな開発が出来ることを目指した改良ライブラリです。

## 背景

私はrioの思想が好みで長く使っています。

しかしrioの好みではない点もいくつかあります。
単純に質の問題であれば私がコントリビュートすれば良いのですが、
非互換な選択である部分が多いため、
それは受け入れられないだろうと考えて、
rioに似たライブラリであるhimariを作成することにしました。

## 目標

### 依存関係が大きくなることを恐れない

例えばrioは依存関係を小さくしようと考えているのか、
[lens](https://hackage.haskell.org/package/lens)ではなく、
[microlens](https://hackage.haskell.org/package/microlens)を採用しています。

しかし実際のライブラリでは本家のlensに依存していることも多いです。
開発でも実際のlensを使いたいです。
その結果コンフリクトすることが多発します。

Haskellは静的にビルドする言語なので、
依存関係が多いことはあまり怖くありません。

ビルドした時に使わないデッドコードはコンパイラが勝手に消してくれます。

他にも使うとは限らない依存関係もドシドシimportしてしまいます。

バージョンごとの依存関係の解決が大変なのは、
Nixなどのパッケージマネージャのレイヤーで解決することにします。

### なるべくimportを一行で済ませることを目指します

himariは基本的には以下の一行で代替Preludeを提供することを目指します。

```haskell
import Himari
```

色々と書くのは面倒なので。
衝突しない範囲で大量にimportしてしまいます。

同じシンボル名をexportしていて衝突してしまうものは仕方がないので、
qualified importを使ってもらいます。

### なるべく独自のシンボルを定義しない

himariはrioで言う`RIO.Text`のような独自のシンボルを定義することをなるべく避けます。
開発メンバーやコーディングエージェントに独自のシンボルを使うことを守ってもらうのが難しいからです。
しばしばオリジナルのシンボルをimportしてしまい、
コードレビューなどで手戻りが発生します。

ただし`Himari.Prelude`のサブモジュールは存在します。
`Himari.Prelude.Aeson`などのシンボルです。
これはHaddockの制限により、
`hiding`を使ったre-exportはシンボルが全て展開されてしまうからです。
シンボルの展開が発生するとドキュメントが肥大化してしまいます。
サブモジュールでhidingを隠蔽することで、
`Himari.Prelude`のドキュメントをコンパクトに保っています。

これらのサブモジュールは`Himari.Prelude`から自動的にre-exportされるため、
rioの`RIO.Text`のように個別にimportする必要はありません。
ユーザから見ると直接扱う必要は基本的にないということです。

万が一誤ってサブモジュールを直接importした場合でも、
`Himari.Prelude`と重複importすることになり、
GHCが警告を出してくれるので、
気が付きやすいです。

## セットアップ

himariを使うプロジェクトでは、
以下の設定ファイルをコピーすることを強く推奨します。

### hlint

himariは部分関数を除去する代わりに、
hlintで警告を出すことで対処しています。
プロジェクトルートにある[.hlint.yaml](./.hlint.yaml)ファイルをコピーしてください。
既存の`hlint.yaml`がある場合はマージしてください。

```console
curl -L 'https://raw.githubusercontent.com/ncaq/himari/master/.hlint.yaml' -o '.hlint.yaml'
```

### fourmolu

[fourmolu](https://github.com/fourmolu/fourmolu)はHaskellのフォーマッタです。
fourmoluは演算子の優先順位(fixity)を正しく解決するために、
カスタムPreludeがどのモジュールをre-exportしているかを知る必要があります。

プロジェクトルートにある、
[fourmolu.yaml](./fourmolu.yaml)ファイルの、
`reexports`セクションをコピーしてください。
既存の`fourmolu.yaml`がある場合は`reexports`セクションをマージしてください。

```console
curl -L 'https://raw.githubusercontent.com/ncaq/himari/master/fourmolu.yaml' -o 'fourmolu.yaml'
```

> [!NOTE]
> fourmolu.yamlにはhimari固有のフォーマット設定(indentation, column-limitなど)も含まれています。
> 素朴な設定ですが、プロジェクトに合わせて適宜変更してください。

## 注意

> [!IMPORTANT]
> himariはrioとは完全に同じように使えるわけではありません。
> ここで主な注意点を挙げます。

### 重大なランタイムの非互換性

#### ログの出力先の変更

rioは基本的に標準出力にログを出力しますが、
himariはデフォルトのセットアップ手順に従うと標準エラー出力にログを出力します。

ログは標準エラー出力に出すべきだと考えているためです。

変更したい時は出力先を`stderr`から`stdout`などに変更することで簡単に変更可能です。

### 部分関数への対処方法の違い

rioは部分関数を独自のモジュールでexportして提供していますが、
himariはそのままオリジナルのモジュールを使う方針です。

よってhimariは部分関数を除去していません。

なのでhimariはhlintのルールで警告を出すことで対処しています。
詳細は[セットアップ](#セットアップ)を参照してください。

## Nix

このプロジェクトは開発環境として、
[haskell.nix](https://input-output-hk.github.io/haskell.nix/)
を使用しています。

あくまで開発環境として利用しているだけなので、
himariを使うのにnixを利用する必要はありません。

### `nix flake show`が失敗する場合

haskell.nixはIFD(Import From Derivation)を使用するため、
複数システムをサポートするflakeで`nix flake show`を実行すると、
異なるシステム向けのビルドを評価しようとして失敗することがあります。

これはhaskell.nixの既知の制限であり、
現在のところ完全な回避策はありません。
