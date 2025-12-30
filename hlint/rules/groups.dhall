-- hlintグループ有効化設定
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    -- `feature`グループは`pure`の代わりに`return`を使うのは好みの問題のため有効化しません。
    -- `partial`グループは`NonEmpty.head`等も誤検出するため有効化せず個別に設定します。
    : List Types.Rule
    = [ Builder.enableGroup "generalise"
      , Builder.enableGroup "dollar"
      , Builder.enableGroup "use-lens"
      , Builder.enableGroup "use-th-quotes"
      ]

in  rules
