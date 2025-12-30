-- String IO警告
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    : List Types.Rule
    = [ Builder.functions
          [ Builder.restrictInModule
              "System.IO"
              "getChar"
              "Encoding depends on LANG env. Use Text or ByteString."
          , Builder.restrictInModule
              "System.IO"
              "getLine"
              "Encoding depends on LANG env. Use Text or ByteString."
          , Builder.restrictInModule
              "System.IO"
              "getContents"
              "Lazy IO + env-dependent encoding. Use strict Text or ByteString."
          , Builder.restrictInModule
              "System.IO"
              "readFile"
              "Lazy IO + env-dependent encoding. Use Data.Text.IO.readFile or Data.ByteString.readFile."
          , Builder.restrictInModule
              "System.IO"
              "interact"
              "Lazy IO + env-dependent encoding."
          , Builder.restrictInModule
              "System.IO"
              "readIO"
              "Env-dependent + partial (uses read)."
          , Builder.restrictInModule
              "System.IO"
              "readLn"
              "Env-dependent + partial (uses read)."
          , Builder.restrictInModule
              "System.IO"
              "putChar"
              "Encoding depends on LANG env. Use Text or ByteString."
          , Builder.restrictInModule
              "System.IO"
              "putStr"
              "Encoding depends on LANG env. Use Text or ByteString."
          , Builder.restrictInModule
              "System.IO"
              "putStrLn"
              "Encoding depends on LANG env. Use Text or ByteString."
          , Builder.restrictInModule
              "System.IO"
              "print"
              "Encoding depends on LANG env. Use Text or ByteString."
          , Builder.restrictInModule
              "System.IO"
              "writeFile"
              "Env-dependent encoding. Use Data.Text.IO.writeFile or Data.ByteString.writeFile."
          , Builder.restrictInModule
              "System.IO"
              "appendFile"
              "Env-dependent encoding. Use Data.Text.IO.appendFile or Data.ByteString.appendFile."
          ]
      ]

in  rules
