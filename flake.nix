{
  inputs = {
    nixpkgs.follows = "haskellNix/nixpkgs-2511";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    haskellNix.url = "github:input-output-hk/haskell.nix";
    changelog-lint-src = {
      url = "git+https://codeberg.org/chavacava/changelog-lint.git";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
      haskellNix,
      changelog-lint-src,
    }:
    let
      ghc-version = "ghc9122"; # GHC 9.12.2
      cabal-version = "3.16.1.0";
      hls-version = "2.12.0.0";
      overlays = [
        haskellNix.overlay
        (
          final: _prev:
          let
            # haskell.nixのtoolsで参照されるhaskell-language-server。
            tool-haskell-language-server =
              final.haskell-nix.tool ghc-version "haskell-language-server"
                hls-version;
          in
          {
            # nixpkgsとhaskell-language-serverの対応バージョンが異なる場合があるため、
            # hlsからパッケージを取ってくる。
            inherit (tool-haskell-language-server.project.hsPkgs.fourmolu.components.exes) fourmolu;
            inherit (tool-haskell-language-server.project.hsPkgs.hlint.components.exes) hlint;
          }
        )
        (final: prev: {
          project = final.haskell-nix.cabalProject' {
            src = ./.;
            compiler-nix-name = ghc-version;
            modules = [
              # `nix flake check`レベルではcabalの警告をエラーとして扱います。
              # ライブラリの問題ない範囲の不一致とか考えるとcabalの警告はエラーにしないべきですが、
              # CIでは通したくないので警告も含めてエラーにします。
              # CI専用に環境を分離するのも手ですが、
              # 元々`nix flake check`では最適化を無効にするのが面倒なので時間がかかるため、
              # あまり反復的に実行しません。
              # 反復的に実行してテストの結果とかを確認するのには普通は`cabal test`のような言語固有のコマンドを使います。
              # `cabal test`の方が実行するテストをフィルタリングとかも簡単に出来ますし。
              # そのことを考えると本番を考えてエラーにしても構わないでしょう。
              # flake参照された時にnixpkgsをfollowすると問題ない警告をエラーにしてしまうかもしれないのが懸念点ですが、
              # 少なくとも現在は考慮する必要はないでしょう。
              # 注意点として、srcやtestはビルドされますが、executableであるappはビルドされません。
              # 「appはエントリーポイントとしてのみ使う」習慣を守っていれば問題にはならないです。
              (
                { lib, config, ... }:
                {
                  # パッケージたちをハードコーディングすると変更忘れが発生するので`config.package-keys`で取得。
                  options.packages = lib.genAttrs config.package-keys (
                    _name:
                    lib.mkOption {
                      type = lib.types.submodule (
                        { config, lib, ... }:
                        # `cabal.project`に`source-repository-package`などで書かれていたりする、
                        # 外部パッケージは変更したくないので、
                        # `isProject`でフィルタリングしています。
                        lib.mkIf config.package.isProject {
                          # この書き方で上書きではなく追加として扱われる。
                          ghcOptions = [ "-Werror" ];
                        }
                      );
                    }
                  );
                }
              )
            ];
            # `ghc-version`だけではなく`variants`で定義したGHCバージョンも`nix flake check`で自動的にテストされます。
            # 個別ビルド: `nix build .#ghc9103:himari:lib:himari`
            # サポート方針としてはサポートできるものは基本的にサポートしていきます。
            # あまりにも古かったり、ビルドが何かしらの問題で出来ないものは除外します。
            flake.variants = {
              ghc9102.compiler-nix-name = final.lib.mkDefault "ghc9102"; # GHC 9.10.2
              ghc9103.compiler-nix-name = final.lib.mkDefault "ghc9103"; # GHC 9.10.3
              ghc9141.compiler-nix-name = final.lib.mkDefault "ghc9141"; # GHC 9.14.1
            };
            shell = {
              tools = {
                cabal = cabal-version;
                cabal-gild = "1.6.0.2"; # treefmtで管理されているがvscodeのHaskell拡張向けに使えるようにしておく
                haskell-language-server = hls-version;
                implicit-hie = "0.1.4.0";
              };
              # ランタイム依存。
              buildInputs = with prev; [
                dhall
                dhall-docs
                dhall-lsp-server
                dhall-yaml
                final.changelog-lint
                fourmolu
                hlint
                nil
                nixfmt-rfc-style
                parallel
                yamllint
                zlib # aesonを開発環境でビルド。

                (writeScriptBin "haskell-language-server-wrapper" ''
                  #!${stdenv.shell}
                  exec haskell-language-server "$@"
                '')
              ];
            };
          };
          changelog-lint = final.buildGoModule {
            pname = "changelog-lint";
            version = "0.3.0";
            src = changelog-lint-src;
            vendorHash = "sha256-b0cTP7aIh26/E9BvG6aGnpktmFmL49Nb8t4AhWvZzP8=";
          };
        })
      ];
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system overlays;
          inherit (haskellNix) config;
        };
        flake = pkgs.project.flake { };
        treefmtEval = treefmt-nix.lib.evalModule pkgs (_: {
          # yamlfmtはprettierと競合する。
          projectRootFile = "flake.nix";
          programs = {
            actionlint.enable = true;
            deadnix.enable = true;
            dhall.enable = true;
            nixfmt.enable = true;
            prettier.enable = true;
            shellcheck.enable = true;
            shfmt.enable = true;
            statix.enable = true;

            hlint = {
              enable = true;
              package = pkgs.hlint;
              # HlintSamplesディレクトリはhlintルールのテスト用であり、意図的に警告を出すコードを含む
              excludes = [ "test/HlintSamples/*" ];
            };

            fourmolu = {
              enable = true;
              package = pkgs.fourmolu;
            };

            # cabal-gildはモジュール自動発見対応のためsettings.formatterでカスタム設定します。
          };
          settings.formatter = {
            # cabal-gildのモジュール自動発見機能に対応するため、
            # Haskellソースファイルの変更も検知してcabal-gildを実行します。
            # treefmt-nixの上流では変更されたファイルだけを修正したいと言われてマージされていませんが、
            # ローカルで使う分には問題ありません。
            # https://github.com/numtide/treefmt-nix/pull/384
            cabal-gild = {
              command = pkgs.lib.getExe (
                pkgs.writeShellApplication {
                  name = "cabal-gild-wrapper";
                  runtimeInputs = [
                    (pkgs.haskell-nix.tool ghc-version "cabal-gild" "1.6.0.2")
                    pkgs.git
                    pkgs.parallel
                  ];
                  text = ''
                    git ls-files -z "*.cabal" | parallel --null "cabal-gild --io {}"
                  '';
                }
              );
              includes = [
                "*.cabal"
                # Haskellソースファイルの変更を検知するために含める
                "*.hs"
                "*.lhs"
                "*.hsc"
                "*.chs"
                "*.hsig"
                "*.lhsig"
              ];
            };
            editorconfig-checker = {
              command = pkgs.lib.getExe (
                pkgs.writeShellApplication {
                  name = "editorconfig-checker-wrapper";
                  runtimeInputs = [ pkgs.editorconfig-checker ];
                  text = ''
                    editorconfig-checker -config .editorconfig-checker.json "$@"
                  '';
                }
              );
              includes = [ "*" ];
              excludes = [
                ".git/*"
                "dist-newstyle/*"
              ];
            };
            changelog-lint = {
              command = pkgs.lib.getExe (
                pkgs.writeShellApplication {
                  name = "changelog-lint-wrapper";
                  runtimeInputs = [ pkgs.changelog-lint ];
                  text = ''
                    changelog-lint -config .changelog-lint.toml "$@"
                  '';
                }
              );
              includes = [ "CHANGELOG.md" ];
            };
            cabal-check = {
              command = pkgs.lib.getExe (
                pkgs.writeShellApplication {
                  name = "cabal-check-wrapper";
                  runtimeInputs = [ (pkgs.haskell-nix.tool ghc-version "cabal" cabal-version) ];
                  text = ''
                    cabal check
                  '';
                }
              );
              includes = [ "*.cabal" ];
            };
          };
        });
      in
      # haskell.nixのproject.flakeはciJobsとhydraJobsを生成するが、
      # ciJobsは非標準のoutputであり警告を誘発し、
      # hydraJobsもGitHub Actionsを使うため不要なので除外。
      builtins.removeAttrs flake [
        "ciJobs"
        "hydraJobs"
      ]
      // {
        apps = flake.apps // {
          generate-hlint = {
            type = "app";
            meta.description = "Generate .hlint.yaml from Dhall source";
            program = pkgs.lib.getExe (
              pkgs.writeShellApplication {
                name = "generate-hlint";
                runtimeInputs = [
                  pkgs.dhall-yaml
                  pkgs.git
                  pkgs.prettier
                ];
                text = ''
                  #!/usr/bin/env bash
                  set -euo pipefail
                  cd "$(git rev-parse --show-toplevel)"
                  {
                    cat <<'HEADER'
                  # himari hlint configuration
                  #
                  # このファイルはDhallによって自動生成されています。
                  # 直接編集しないでください。
                  #
                  # himariが推奨するスタイルを機械的にチェックするためのhlint設定ファイルです。
                  # 部分関数や危険な関数の使用を警告したり、
                  # より可読性の高いパターンを提案します。
                  #
                  # 使い方:
                  #   * このファイルをプロジェクトルートに .hlint.yaml としてコピー
                  #   * または .hlint.yaml から参照: - arguments: [--hint=path/to/this/.hlint.yaml]
                  HEADER
                    dhall-to-yaml-ng --file hlint/hlint.dhall
                  } > .hlint.yaml
                  prettier --write .hlint.yaml
                '';
              }
            );
          };
        };
        checks =
          flake.packages # テストがないパッケージもビルドしてエラーを検出する。
          // flake.checks
          // {
            formatting = treefmtEval.config.build.check self;
          };
        formatter = treefmtEval.config.build.wrapper;
      }
    );

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org/"
      "https://niks3-public.ncaq.net/"
      "https://ncaq.cachix.org/"
      "https://nix-community.cachix.org/"
      "https://cache.iog.io/"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "niks3-public.ncaq.net-1:e/B9GomqDchMBmx3IW/TMQDF8sjUCQzEofKhpehXl04="
      "ncaq.cachix.org-1:XF346GXI2n77SB5Yzqwhdfo7r0nFcZBaHsiiMOEljiE="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
    allow-import-from-derivation = true; # haskell.nixの仕様でshowやcheckで必要になる。
  };
}
