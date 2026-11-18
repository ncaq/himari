-- String IO警告
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let dependLangMessage = "Encoding depends on LANG env. Use Text or ByteString."

let getChar =
      Builder.restrictReexportedBySafePrelude
        "System.IO"
        "getChar"
        dependLangMessage

let getLine =
      Builder.restrictReexportedBySafePrelude
        "System.IO"
        "getLine"
        dependLangMessage

let getContentsMessage =
      "Lazy IO + env-dependent encoding. Use strict Text or ByteString."

let getContents =
      Builder.restrictReexportedBySafePrelude
        "System.IO"
        "getContents"
        getContentsMessage

let readFileMessage =
      "Lazy IO + env-dependent encoding. Use Data.Text.IO.readFile or Data.ByteString.readFile."

let readFile =
      Builder.restrictReexportedBySafePrelude
        "System.IO"
        "readFile"
        readFileMessage

let interactMessage = "Lazy IO + env-dependent encoding."

let interact =
      Builder.restrictReexportedBySafePrelude
        "System.IO"
        "interact"
        interactMessage

let readIOMessage = "Env-dependent + partial (uses read)."

let readIO =
      Builder.restrictReexportedBySafePrelude "System.IO" "readIO" readIOMessage

let readLnMessage = "Env-dependent + partial (uses read)."

let readLn =
      Builder.restrictReexportedBySafePrelude "System.IO" "readLn" readLnMessage

let putChar =
      Builder.restrictReexportedBySafePrelude
        "System.IO"
        "putChar"
        dependLangMessage

let putStr =
      Builder.restrictReexportedBySafePrelude
        "System.IO"
        "putStr"
        dependLangMessage

let putStrLn =
      Builder.restrictReexportedBySafePrelude
        "System.IO"
        "putStrLn"
        dependLangMessage

let print =
      Builder.restrictReexportedBySafePrelude
        "System.IO"
        "print"
        dependLangMessage

let writeFileMessage =
      "Env-dependent encoding. Use Data.Text.IO.writeFile or Data.ByteString.writeFile."

let writeFile =
      Builder.restrictReexportedBySafePrelude
        "System.IO"
        "writeFile"
        writeFileMessage

let appendFileMessage =
      "Env-dependent encoding. Use Data.Text.IO.appendFile or Data.ByteString.appendFile."

let appendFile =
      Builder.restrictReexportedBySafePrelude
        "System.IO"
        "appendFile"
        appendFileMessage

let rules
    : List Types.Rule
    = [ Builder.functions
          (   getChar
            # getLine
            # getContents
            # readFile
            # interact
            # readIO
            # readLn
            # putChar
            # putStr
            # putStrLn
            # print
            # writeFile
            # appendFile
          )
      ]

in  rules
