-- String IO警告
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let getCharMessage = "Encoding depends on LANG env. Use Text or ByteString."

let getChar = Builder.restrictInModule "System.IO" "getChar" getCharMessage

let getLineMessage = "Encoding depends on LANG env. Use Text or ByteString."

let getLine = Builder.restrictInModule "System.IO" "getLine" getLineMessage

let getContentsMessage =
      "Lazy IO + env-dependent encoding. Use strict Text or ByteString."

let getContents =
      Builder.restrictInModule "System.IO" "getContents" getContentsMessage

let readFileMessage =
      "Lazy IO + env-dependent encoding. Use Data.Text.IO.readFile or Data.ByteString.readFile."

let readFile = Builder.restrictInModule "System.IO" "readFile" readFileMessage

let interactMessage = "Lazy IO + env-dependent encoding."

let interact = Builder.restrictInModule "System.IO" "interact" interactMessage

let readIOMessage = "Env-dependent + partial (uses read)."

let readIO = Builder.restrictInModule "System.IO" "readIO" readIOMessage

let readLnMessage = "Env-dependent + partial (uses read)."

let readLn = Builder.restrictInModule "System.IO" "readLn" readLnMessage

let putCharMessage = "Encoding depends on LANG env. Use Text or ByteString."

let putChar = Builder.restrictInModule "System.IO" "putChar" putCharMessage

let putStrMessage = "Encoding depends on LANG env. Use Text or ByteString."

let putStr = Builder.restrictInModule "System.IO" "putStr" putStrMessage

let putStrLnMessage = "Encoding depends on LANG env. Use Text or ByteString."

let putStrLn = Builder.restrictInModule "System.IO" "putStrLn" putStrLnMessage

let printMessage = "Encoding depends on LANG env. Use Text or ByteString."

let print = Builder.restrictInModule "System.IO" "print" printMessage

let writeFileMessage =
      "Env-dependent encoding. Use Data.Text.IO.writeFile or Data.ByteString.writeFile."

let writeFile =
      Builder.restrictInModule "System.IO" "writeFile" writeFileMessage

let appendFileMessage =
      "Env-dependent encoding. Use Data.Text.IO.appendFile or Data.ByteString.appendFile."

let appendFile =
      Builder.restrictInModule "System.IO" "appendFile" appendFileMessage

let rules
    : List Types.Rule
    = [ Builder.functions
          [ getChar
          , getLine
          , getContents
          , readFile
          , interact
          , readIO
          , readLn
          , putChar
          , putStr
          , putStrLn
          , print
          , writeFile
          , appendFile
          ]
      ]

in  rules
