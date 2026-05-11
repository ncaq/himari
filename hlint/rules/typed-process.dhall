-- System.Process -> System.Process.Typed優先ルール
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let callProcessMessage =
      "Use System.Process.Typed.runProcess_ instead for type-safe process execution."

let callProcess =
      Builder.restrictInModule "System.Process" "callProcess" callProcessMessage

let callCommandMessage =
      "Use System.Process.Typed.runProcess_ with shell instead for type-safe process execution."

let callCommand =
      Builder.restrictInModule "System.Process" "callCommand" callCommandMessage

let spawnProcessMessage =
      "Use System.Process.Typed.startProcess instead for type-safe process execution."

let spawnProcess =
      Builder.restrictInModule
        "System.Process"
        "spawnProcess"
        spawnProcessMessage

let spawnCommandMessage =
      "Use System.Process.Typed.startProcess with shell instead for type-safe process execution."

let spawnCommand =
      Builder.restrictInModule
        "System.Process"
        "spawnCommand"
        spawnCommandMessage

let createProcessMessage =
      "Use System.Process.Typed.startProcess instead for type-safe process execution."

let createProcess =
      Builder.restrictInModule
        "System.Process"
        "createProcess"
        createProcessMessage

let createProcessUnderscoreMessage =
      "Use System.Process.Typed.startProcess instead for type-safe process execution."

let createProcessUnderscore =
      Builder.restrictInModule
        "System.Process"
        "createProcess_"
        createProcessUnderscoreMessage

let cleanupProcessMessage =
      "Use System.Process.Typed.stopProcess instead for type-safe process cleanup."

let cleanupProcess =
      Builder.restrictInModule
        "System.Process"
        "cleanupProcess"
        cleanupProcessMessage

let readProcessMessage =
      "Use System.Process.Typed.readProcessStdout instead for type-safe output capture."

let readProcess =
      Builder.restrictInModule "System.Process" "readProcess" readProcessMessage

let readProcessWithExitCodeMessage =
      "Use System.Process.Typed.readProcess instead for type-safe output capture."

let readProcessWithExitCode =
      Builder.restrictInModule
        "System.Process"
        "readProcessWithExitCode"
        readProcessWithExitCodeMessage

let readCreateProcessMessage =
      "Use System.Process.Typed.readProcessStdout instead for type-safe output capture."

let readCreateProcess =
      Builder.restrictInModule
        "System.Process"
        "readCreateProcess"
        readCreateProcessMessage

let readCreateProcessWithExitCodeMessage =
      "Use System.Process.Typed.readProcess instead for type-safe output capture."

let readCreateProcessWithExitCode =
      Builder.restrictInModule
        "System.Process"
        "readCreateProcessWithExitCode"
        readCreateProcessWithExitCodeMessage

let waitForProcessMessage =
      "Use System.Process.Typed.waitExitCode instead for MonadIO support."

let waitForProcess =
      Builder.restrictInModule
        "System.Process"
        "waitForProcess"
        waitForProcessMessage

let getProcessExitCodeMessage =
      "Use System.Process.Typed.getExitCode instead for MonadIO support."

let getProcessExitCode =
      Builder.restrictInModule
        "System.Process"
        "getProcessExitCode"
        getProcessExitCodeMessage

let terminateProcessMessage =
      "Use System.Process.Typed.stopProcess instead for proper cleanup."

let terminateProcess =
      Builder.restrictInModule
        "System.Process"
        "terminateProcess"
        terminateProcessMessage

let interruptProcessGroupOfMessage =
      "Consider using System.Process.Typed with setCreateGroup for process group management."

let interruptProcessGroupOf =
      Builder.restrictInModule
        "System.Process"
        "interruptProcessGroupOf"
        interruptProcessGroupOfMessage

let runCommandMessage =
      "Use System.Process.Typed.runProcess with shell instead for type-safe process execution."

let runCommand =
      Builder.restrictInModule "System.Process" "runCommand" runCommandMessage

let runProcessMessage =
      "Use System.Process.Typed.runProcess instead for type-safe process execution."

let runProcess =
      Builder.restrictInModule "System.Process" "runProcess" runProcessMessage

let runInteractiveCommandMessage =
      "Use System.Process.Typed.startProcess with shell and createPipe instead."

let runInteractiveCommand =
      Builder.restrictInModule
        "System.Process"
        "runInteractiveCommand"
        runInteractiveCommandMessage

let runInteractiveProcessMessage =
      "Use System.Process.Typed.startProcess with createPipe instead."

let runInteractiveProcess =
      Builder.restrictInModule
        "System.Process"
        "runInteractiveProcess"
        runInteractiveProcessMessage

let systemMessage =
      "Use System.Process.Typed.runProcess with shell instead for type-safe process execution."

let system = Builder.restrictInModule "System.Process" "system" systemMessage

let rawSystemMessage =
      "Use System.Process.Typed.runProcess instead for type-safe process execution."

let rawSystem =
      Builder.restrictInModule "System.Process" "rawSystem" rawSystemMessage

let procMessage =
      "Use System.Process.Typed.proc instead for type-safe ProcessConfig."

let proc = Builder.restrictInModule "System.Process" "proc" procMessage

let shellMessage =
      "Use System.Process.Typed.shell instead for type-safe ProcessConfig."

let shell = Builder.restrictInModule "System.Process" "shell" shellMessage

let withCreateProcessMessage =
          "Use System.Process.Typed.withProcessWait or withProcessTerm instead "
      ++  "for MonadUnliftIO support."

let withCreateProcess =
      Builder.restrictInModule
        "System.Process"
        "withCreateProcess"
        withCreateProcessMessage

let withCreateProcessUnderscoreMessage =
          "Use System.Process.Typed.withProcessWait_ or withProcessTerm_ instead "
      ++  "for MonadUnliftIO support."

let withCreateProcessUnderscore =
      Builder.restrictInModule
        "System.Process"
        "withCreateProcess_"
        withCreateProcessUnderscoreMessage

let rules
    : List Types.Rule
    = [ Builder.functions
          [ callProcess
          , callCommand
          , spawnProcess
          , spawnCommand
          , createProcess
          , createProcessUnderscore
          , cleanupProcess
          , readProcess
          , readProcessWithExitCode
          , readCreateProcess
          , readCreateProcessWithExitCode
          , waitForProcess
          , getProcessExitCode
          , terminateProcess
          , interruptProcessGroupOf
          , runCommand
          , runProcess
          , runInteractiveCommand
          , runInteractiveProcess
          , system
          , rawSystem
          , proc
          , shell
          , withCreateProcess
          , withCreateProcessUnderscore
          ]
      ]

in  rules
