-- hlintルールのビルダー関数
let Prelude =
      https://prelude.dhall-lang.org/v23.1.0/package.dhall
        sha256:931cbfae9d746c4611b07633ab1e547637ab4ba138b16bf65ef1b9ad66a60b7f

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

let functions
    : List Types.Function -> Types.Rule
    = \(fs : List Types.Function) -> Types.Rule.Functions { functions = fs }

let hint
    : Text -> Text -> Optional Text -> Types.Rule
    = \(lhs : Text) ->
      \(rhs : Text) ->
      \(note : Optional Text) ->
        Types.Rule.Hint { hint = { lhs, rhs, note } }

let useConvert
    : Text -> Types.Rule
    = \(lhs : Text) ->
        hint
          lhs
          "convert"
          (Some "Use convert from Data.Convertible for uniform type conversion")

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
        , importStyle = Some Types.ImportStyle.qualified
        , qualifiedStyle = None Types.QualifiedStyle
        , within = None (List Text)
        , message = None Text
        }

let qualifiedAsRequired
    : Text -> Text -> Types.Module
    = \(name : Text) ->
      \(moduleAlias : Text) ->
        { name
        , `as` = Some moduleAlias
        , asRequired = Some True
        , importStyle = Some Types.ImportStyle.qualified
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

in  { restrictFunction
    , restrictInModule
    , functions
    , hint
    , useConvert
    , enableGroup
    , preferModule
    , modules
    , qualifiedAs
    , qualifiedAsRequired
    , banModule
    , Prelude
    }
