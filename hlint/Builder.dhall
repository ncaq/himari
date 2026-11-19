-- hlintルールのビルダー関数
let Prelude = ./Prelude.dhall

let Types = ./Types.dhall

let restrictFunction
    : Text -> Text -> Types.Function
    = \(name : Text) ->
      \(message : Text) ->
        { name, within = [] : List Text, message }

let restrictInModule
    : Text -> Text -> Text -> Types.Function
    = \(module : Text) ->
      \(func : Text) ->
      \(message : Text) ->
        restrictFunction "${module}.${func}" message

let -- hlintはimport宣言に書かれたモジュール名だけでシンボルの由来を判断するため、
    -- 再エクスポートを追跡しません。
    -- 定義元のモジュール名で修飾したルールは`import Himari`経由のシンボルに一致しないので、
    -- 再エクスポートしているhimariのモジュール名で修飾したルールも生成します。
    -- himariが同じ名前で別の実体をエクスポートしている関数に使ってはいけません。
    -- 定義元が違っても同じ実体になる関数は、
    -- hlintが一致したルールのメッセージを全て連結してしまうので、
    -- どれか1つのルールにだけ使ってください。
    restrictReexported
    : List Text -> Text -> Text -> Text -> List Types.Function
    = \(reexporters : List Text) ->
      \(module : Text) ->
      \(func : Text) ->
      \(message : Text) ->
        Prelude.List.map
          Text
          Types.Function
          (\(m : Text) -> restrictInModule m func message)
          ([ module ] # reexporters)

let -- `Himari.SafePrelude`が再エクスポートしている関数を制限します。
    -- `Himari.SafePrelude`は`Himari.Prelude`と`Himari`からも再エクスポートされているので、
    -- 3つのモジュール名のルールを生成します。
    -- `Himari.SafePrelude`が定義元と同じ実体をエクスポートしていることを確認してから使ってください。
    -- baseやlensの関数の多くが該当しますが、
    -- `Himari.SafePrelude`がエクスポートしていない関数や`hiding`している関数に使うと、
    -- 存在しないシンボルに対するルールが生成されます。
    restrictReexportedBySafePrelude
    : Text -> Text -> Text -> List Types.Function
    = restrictReexported [ "Himari", "Himari.Prelude", "Himari.SafePrelude" ]

let -- `Himari.Prelude`が再エクスポートしていて、
    -- `Himari.SafePrelude`には含まれない関数を制限します。
    -- `Himari.Prelude`が定義元と同じ実体をエクスポートしていて、
    -- `Himari.SafePrelude`はエクスポートしていないことを確認してから使ってください。
    -- UnliftIOの関数の多くが該当します。
    restrictReexportedByPrelude
    : Text -> Text -> Text -> List Types.Function
    = restrictReexported [ "Himari", "Himari.Prelude" ]

let functions
    : List Types.Function -> Types.Rule
    = \(fs : List Types.Function) -> Types.Rule.Functions { functions = fs }

let hint
    : Text -> Text -> Optional Text -> Types.Rule
    = \(lhs : Text) ->
      \(rhs : Text) ->
      \(note : Optional Text) ->
        Types.Rule.Hint { hint = { lhs, rhs, note } }

let useSafeConvert
    : Text -> Types.Rule
    = \(name : Text) ->
        functions
          [ restrictFunction
              name
              (     "Use safeConvert from Data.Convertible to surface conversion errors"
                ++  " as Either ConvertError instead of relying on a partial function"
              )
          ]

let enableGroup
    : Text -> Types.Rule
    = \(name : Text) -> Types.Rule.Group { group = { name, enabled = True } }

let preferModule
    : Text -> Text -> Text -> List Text -> List Types.Function
    = \(fromModule : Text) ->
      \(toModule : Text) ->
      \(reason : Text) ->
      \(funcs : List Text) ->
        Prelude.List.map
          Text
          Types.Function
          ( \(func : Text) ->
              restrictInModule
                fromModule
                func
                "Use ${toModule}.${func} instead ${reason}"
          )
          funcs

let modules
    : List Types.Module -> Types.Rule
    = \(ms : List Types.Module) -> Types.Rule.Modules { modules = ms }

let qualifiedAs
    : Text -> Text -> Types.Module
    = \(name : Text) ->
      \(moduleAlias : Text) ->
        { name
        , `as` = Some moduleAlias
        , asRequired = None Bool
        , importStyle = Some Types.ImportStyle.explicitOrQualified
        , qualifiedStyle = None Types.QualifiedStyle
        , within = None (List Text)
        , message = None Text
        }

let banModule
    : Text -> Text -> Types.Module
    = \(name : Text) ->
      \(reason : Text) ->
        { name
        , `as` = None Text
        , asRequired = None Bool
        , importStyle = None Types.ImportStyle
        , qualifiedStyle = None Types.QualifiedStyle
        , within = Some ([] : List Text)
        , message = Some reason
        }

let extensionNames
    : List Text -> Types.ExtensionItem
    = \(names : List Text) ->
        Types.ExtensionItem.Name
          { name = names, within = None (List Text), message = None Text }

let extensionNamesWithin
    : List Text -> List Text -> Types.ExtensionItem
    = \(names : List Text) ->
      \(within : List Text) ->
        Types.ExtensionItem.Name
          { name = names, within = Some within, message = None Text }

let banExtensionWithMessage
    : List Text -> Text -> Types.ExtensionItem
    = \(names : List Text) ->
      \(msg : Text) ->
        Types.ExtensionItem.Name
          { name = names, within = Some ([] : List Text), message = Some msg }

let extensions
    : List Types.ExtensionItem -> Types.Rule
    = \(exts : List Types.ExtensionItem) ->
        Types.Rule.Extensions { extensions = exts }

in  { restrictFunction
    , restrictInModule
    , restrictReexportedBySafePrelude
    , restrictReexportedByPrelude
    , functions
    , hint
    , useSafeConvert
    , enableGroup
    , preferModule
    , modules
    , qualifiedAs
    , banModule
    , extensionNames
    , extensionNamesWithin
    , banExtensionWithMessage
    , extensions
    }
