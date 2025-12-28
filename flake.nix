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
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
      haskellNix,
    }:
    # 現状はLinuxのみを想定。
    let
      ghc-version = "ghc9102";
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
            # nixpkgsで普通にインストールされるfourmoluはhaskell-language-serverのものと違うので上書きして合わせる。
            inherit (tool-haskell-language-server.project.hsPkgs.fourmolu.components.exes) fourmolu;
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
            shell = {
              tools = {
                cabal = "3.14.2.0";
                cabal-gild = "1.6.0.2"; # treefmtで管理されているがvscodeのHaskell拡張向けに使えるようにしておく
                haskell-language-server = hls-version;
                implicit-hie = "0.1.4.0";
              };
              # ランタイム依存。
              buildInputs = with prev; [
                fourmolu
                nil
                nixfmt-rfc-style
                parallel
                yamllint

                (writeScriptBin "haskell-language-server-wrapper" ''
                  #!${stdenv.shell}
                  exec haskell-language-server "$@"
                '')
              ];
            };
          };
        })
      ];
    in
    flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux ] (
      system:
      let
        pkgs = import nixpkgs {
          inherit system overlays;
          inherit (haskellNix) config;
        };
        flake = pkgs.project.flake { };
        treefmtEval = treefmt-nix.lib.evalModule pkgs (_: {
          # actionlintはセルフホストランナーの設定ファイルを正常に読み込まなかった。
          # yamlfmtはprettierと競合する。
          projectRootFile = "flake.nix";
          programs = {
            cabal-gild.enable = true;
            deadnix.enable = true;
            hlint.enable = true;
            nixfmt.enable = true;
            prettier.enable = true;
            shellcheck.enable = true;
            shfmt.enable = true;
            statix.enable = true;

            fourmolu = {
              enable = true;
              package = pkgs.fourmolu;
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
      "https://nix-community.cachix.org"
      "https://cache.iog.io"
      "https://himari.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "himari.cachix.org-1:HNryUKdm68QKCNuC8GkQb2oJ5emKE/degaYBOVrU9wY="
    ];
    allow-import-from-derivation = true; # haskell.nixの仕様でshowやcheckで必要になる。
  };
}
