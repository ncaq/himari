{
  inputs = {
    nixpkgs.follows = "haskellNix/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
    inputs@{
      nixpkgs,
      flake-parts,
      treefmt-nix,
      haskellNix,
      changelog-lint-src,
      ...
    }:
    let
      # `cabal.project`の`with-compiler`で指定したGHCバージョンを尊重し、
      # 対応するnixpkgsのパッケージセットを選択します。
      # こうすることでGHCバージョンの管理が`cabal.project`に一元化されます。
      cabalHaskellGhcVersion =
        let
          m = builtins.match ".*with-compiler:[[:space:]]*ghc-([0-9.]+).*" (
            builtins.readFile ./cabal.project
          );
        in
        if m == null then throw "cabal.projectにwith-compilerが見つかりません" else builtins.head m;
      ghc-version = "ghc${builtins.replaceStrings [ "." ] [ "" ] cabalHaskellGhcVersion}";
      cabal-version = "3.16.1.0";
      hls-version = "2.13.0.0";
      # cabalビルドに必要なファイルのみを含める。
      # 関係ないファイル(.editorconfig, .githubなど)の変更で内部derivationのhashが動き、
      # キャッシュミスが発生するのを避ける。
      cabalFileset =
        lib:
        lib.fileset.toSource {
          root = ./.;
          fileset = lib.fileset.unions [
            # dir
            ./example
            ./src
            ./test
            # file
            ./cabal.project
            ./himari.cabal
            # license-file
            ./LICENSE
            # extra-source-files
            ./.hlint.yaml
            # extra-doc-files
            ./CHANGELOG.md
            ./README.md
          ];
        };
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
            src = cabalFileset final.lib;
            compiler-nix-name = ghc-version;
            modules = [
              # `nix flake check`レベルではcabalの警告をエラーとして扱います。
              # ライブラリの問題ない範囲の不一致とか考えるとcabalの警告はエラーにしないべきですが、
              # CIでは通したくないので警告も含めてエラーにします。
              # 注意点としてsrcやtestはビルドされますが、
              # executableであるappはビルドされません。
              # 「appはエントリーポイントとしてのみ使う」習慣を守っていれば、
              # 問題にはならないはずです。
              (
                { lib, config, ... }:
                {
                  # パッケージたちをハードコーディングすると変更忘れが発生するので、
                  # `config.package-keys`で取得。
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
            # `ghc-version`だけではなく、
            # `variants`で定義したGHCバージョンも`nix flake check`で自動的にテストされます。
            # 個別ビルド: `nix build .#ghc9103:himari:lib:himari`
            # サポート方針としてはサポートできるものは基本的にサポートしていきます。
            # あまりにも古かったり、ビルドが何かしらの問題で出来ないものは除外します。
            flake.variants = {
              ghc9102.compiler-nix-name = final.lib.mkDefault "ghc9102"; # GHC 9.10.2
              ghc9103.compiler-nix-name = final.lib.mkDefault "ghc9103"; # GHC 9.10.3
              ghc9122.compiler-nix-name = final.lib.mkDefault "ghc9122"; # GHC 9.12.2
              ghc9123.compiler-nix-name = final.lib.mkDefault "ghc9123"; # GHC 9.12.3
              # 9.12.4はデフォルト選択なので省略。
              ghc9141.compiler-nix-name = final.lib.mkDefault "ghc9141"; # GHC 9.14.1
            };
            shell = {
              tools = {
                cabal = cabal-version;
                cabal-gild = "1.6.0.4"; # treefmtで管理されているが広く使えるように。
                haskell-language-server = hls-version;
                implicit-hie = "0.1.4.0";
              };
              # ランタイム依存。
              buildInputs = with prev; [
                # treefmtで指定したプログラムの単体版。
                actionlint
                deadnix
                editorconfig-checker
                final.changelog-lint
                fourmolu
                hlint
                nixfmt
                prettier
                shellcheck
                shfmt
                statix
                typos
                zizmor

                # nixの関連ツール。
                nil

                # GitHub関連ツール。
                gh

                # Dhall関連ツール。
                dhall
                dhall-docs
                dhall-lsp-server
                dhall-yaml

                # Haskell関連ツール。
                parallel
                zlib # aesonを開発環境でビルド。

                # その他。
                yamllint

                (writeScriptBin "haskell-language-server-wrapper" ''
                  #!${stdenv.shell}
                  exec haskell-language-server "$@"
                '')
              ];
            };
          };
          # stackageの最新LTSスナップショットでビルド・テストできることを検証するプロジェクト。
          # 通常の`project`(cabalProject)は、
          # Cabalソルバーがindex-state時点のHackageから制約を満たす最新版を選びますが、
          # stackageは固定されたバージョンセット(snapshot)でビルドするため、
          # 別経路の検証として価値があります。
          # `resolver`を`stack.yaml`にハードコードすると更新忘れが起きるため、
          # `flake.lock`に固定された`haskell.nix`のstackageデータの中から、
          # 最新のLTSを自動的に選択します。
          # `nix flake update`でhaskell.nixが更新されれば検証対象も自動で追従します。
          himari-stackage-project =
            let
              # `lts-MAJOR.MINOR`はMINORが2桁になると単純な文字列ソートでは順序が崩れるため、
              # 数値を考慮する`naturalSort`で最新を選びます。
              latestLts = final.lib.last (
                final.lib.naturalSort (
                  builtins.filter (final.lib.hasPrefix "lts-") (builtins.attrNames final.haskell-nix.snapshots)
                )
              );
              # `cabalFileset`を基に`stack.yaml`を動的生成したソースツリーを作ります。
              stackageSrc = final.runCommand "himari-stackage-src" { } ''
                cp -r ${cabalFileset final.lib} "$out"
                chmod -R +w "$out"
                printf 'resolver: ${latestLts}\npackages:\n  - .\n' > "$out/stack.yaml"
              '';
              # haskell.nixはstackageがピンするboot library(unix, filepathなど)を、
              # Hackageから再ビルドしようとするが、
              # unixの`os-string`依存の配線失敗などでビルドが壊れる。
              # stackage本家のCIはこれらをGHC同梱のグローバルパッケージとして扱い再ビルドしないため、
              # これはhaskell.nix固有の問題。
              # 再ビルドせずGHC同梱版を使ってもスナップショットとの忠実性は損なわれない。
              # むしろグローバルパッケージをGHCに固定するstackage本家の挙動に一致する。
              # override無しの素のプロジェクトを用意し、
              # その既定の`nonReinstallablePkgs`にGHC同梱パッケージ全体を加える。
              # `nonReinstallablePkgs`のマージは最後の定義が優先される(全置換)仕様のため、
              # 既定値を読み取って継ぎ足すことでhaskell.nixの既定リストの変化にも追従する。
              baseProject = final.haskell-nix.stackProject' { src = stackageSrc; };
              # プロジェクトが実際に使うGHCの同梱パッケージ名一覧。
              # 最新LTSがGHCバージョンを跨いで変わっても自動追従するよう、
              # 名前をハードコードせずGHCから取得する。
              ghcBundledPkgs =
                let
                  ghc = baseProject.pkg-set.config.ghc.package;
                in
                builtins.filter (s: s != "") (
                  final.lib.splitString "\n" (
                    final.lib.fileContents (
                      final.runCommand "ghc-bundled-package-names" { } ''
                        ${ghc}/bin/ghc-pkg --global list --simple-output \
                          | tr ' ' '\n' \
                          | sed -E 's/-[0-9][0-9.]*$//' \
                          | sort -u > "$out"
                      ''
                    )
                  )
                );
            in
            final.haskell-nix.stackProject' {
              src = stackageSrc;
              modules = [
                { nonReinstallablePkgs = baseProject.pkg-set.config.nonReinstallablePkgs ++ ghcBundledPkgs; }
              ];
            };
          # nixpkgsにないので埋め込み。
          changelog-lint = final.buildGoModule {
            pname = "changelog-lint";
            version = "0.3.0";
            src = changelog-lint-src;
            vendorHash = "sha256-b0cTP7aIh26/E9BvG6aGnpktmFmL49Nb8t4AhWvZzP8=";
          };
        })
      ];
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        treefmt-nix.flakeModule
      ];

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      perSystem =
        { system, ... }:
        let
          pkgs = import nixpkgs {
            inherit system overlays;
            inherit (haskellNix) config;
          };
          flake = pkgs.project.flake { };
          # stackageのスナップショットでビルドしたhimariライブラリ。
          himari-stackage = pkgs.himari-stackage-project.hsPkgs.himari.components.library;
          # stackage上でのパッケージのテスト実行。
          himari-stackage-test = pkgs.haskell-nix.haskellLib.check pkgs.himari-stackage-project.hsPkgs.himari.components.tests.himari-test;
          # nixpkgsの`haskellPackages`越しにhimariをビルド・テストする派生。
          # haskell.nixはCabalソルバーで依存解決するため柔軟だが、
          # 素のnixpkgsは1パッケージ1バージョン固定なので、
          # 依存パッケージのバージョン変動などでビルド・テストが失敗することがある。
          # nixpkgs越しでも壊れていないことを継続的に検証する。
          himari-nixpkgs = pkgs.haskellPackages.callCabal2nix "himari" (cabalFileset pkgs.lib) { };
          # `haskell.nix`の生成したパッケージとその他のものをまとめます。
          packages = flake.packages // {
            inherit himari-stackage himari-nixpkgs;
          };
        in
        {
          treefmt.config = {
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
              typos.enable = true;
              zizmor.enable = true;

              hlint = {
                enable = true;
                package = pkgs.hlint;
                # HlintSamplesディレクトリはhlintルールのテスト用であり、
                # 意図的に警告を出すコードを含むため、
                # hlintの対象から除外します。
                # 本当はこういうのはhlintの設定として書くべきかもしれませんが、
                # 現状配布するhlintのルールとプロジェクトで使うルールが同じなので、
                # こちらで除外しています。
                # 乖離が激しくなってきたら配布するものは分けることも検討します。
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
              # treefmt-nixの上流では、
              # 変更されたファイルだけを修正したいと言われてマージされていませんが、
              # ローカルで使う分には問題ありません。
              # https://github.com/numtide/treefmt-nix/pull/384
              cabal-gild = {
                command = pkgs.lib.getExe (
                  pkgs.writeShellApplication {
                    name = "cabal-gild-wrapper";
                    runtimeInputs = [
                      (pkgs.haskell-nix.tool ghc-version "cabal-gild" "1.6.0.4")
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
              editorconfig-checker = {
                command = pkgs.editorconfig-checker;
                includes = [ "*" ];
                excludes = [
                  "dist-newstyle/*"
                ];
              };
              zizmor.options = [ "--pedantic" ];
            };
          };

          checks =
            # テストがないパッケージもビルドしてエラーを検出する。
            # テストの実行パッケージを後に書くことで上書き。
            packages // flake.checks // { inherit himari-stackage-test; };

          inherit packages;

          apps = flake.apps // {
            generate-hlint = {
              type = "app";
              meta.description = "Generate .hlint.yaml from Dhall source";
              program = pkgs.lib.getExe (
                pkgs.writeShellApplication {
                  name = "generate-hlint";
                  runtimeInputs = with pkgs; [
                    dhall-yaml
                    git
                    prettier
                  ];
                  text = ''
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

          inherit (flake) devShells;
        };
    };

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
