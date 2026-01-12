-- hlint設定の型定義

-- 関数制限の型
let Function
    : Type
    = { name : Text, within : List Text, message : Text }

let Hint
    : Type
    = { lhs : Text, rhs : Text, note : Optional Text }

let Group
    : Type
    = { name : Text, enabled : Bool }

let ImportStyle
    : Type
    = < qualified | unqualified | explicitOrQualified | unrestricted >

let QualifiedStyle
    : Type
    = < pre | post >

let Module
    : Type
    = { name : Text
      , `as` : Optional Text
      , asRequired : Optional Bool
      , importStyle : Optional ImportStyle
      , qualifiedStyle : Optional QualifiedStyle
      , within : Optional (List Text)
      , message : Optional Text
      }

let ExtensionItem
    : Type
    = < Default : Bool
      | Name :
          { name : List Text
          , within : Optional (List Text)
          , message : Optional Text
          }
      >

let Rule
    : Type
    = < Functions : { functions : List Function }
      | Hint : { hint : Hint }
      | Group : { group : Group }
      | Arguments : { arguments : List Text }
      | Modules : { modules : List Module }
      | Extensions : { extensions : List ExtensionItem }
      >

in  { Function
    , Hint
    , Group
    , ImportStyle
    , QualifiedStyle
    , Module
    , ExtensionItem
    , Rule
    }
