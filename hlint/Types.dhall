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

let Rule
    : Type
    = < Functions : { functions : List Function }
      | Hint : { hint : Hint }
      | Group : { group : Group }
      | Arguments : { arguments : List Text }
      >

in  { Function, Hint, Group, Rule }
