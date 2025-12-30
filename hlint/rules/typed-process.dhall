-- System.Process -> System.Process.Typed優先ルール
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let rules
    : List Types.Rule
    = [ Builder.functions
          [ Builder.restrictInModule
              "System.Process"
              "callProcess"
              "Use System.Process.Typed.runProcess_ instead for type-safe process execution."
          , Builder.restrictInModule
              "System.Process"
              "callCommand"
              "Use System.Process.Typed.runProcess_ with shell instead for type-safe process execution."
          , Builder.restrictInModule
              "System.Process"
              "spawnProcess"
              "Use System.Process.Typed.startProcess instead for type-safe process execution."
          , Builder.restrictInModule
              "System.Process"
              "spawnCommand"
              "Use System.Process.Typed.startProcess with shell instead for type-safe process execution."
          , Builder.restrictInModule
              "System.Process"
              "createProcess"
              "Use System.Process.Typed.startProcess instead for type-safe process execution."
          , Builder.restrictInModule
              "System.Process"
              "createProcess_"
              "Use System.Process.Typed.startProcess instead for type-safe process execution."
          , Builder.restrictInModule
              "System.Process"
              "cleanupProcess"
              "Use System.Process.Typed.stopProcess instead for type-safe process cleanup."
          , Builder.restrictInModule
              "System.Process"
              "readProcess"
              "Use System.Process.Typed.readProcessStdout instead for type-safe output capture."
          , Builder.restrictInModule
              "System.Process"
              "readProcessWithExitCode"
              "Use System.Process.Typed.readProcess instead for type-safe output capture."
          , Builder.restrictInModule
              "System.Process"
              "readCreateProcess"
              "Use System.Process.Typed.readProcessStdout instead for type-safe output capture."
          , Builder.restrictInModule
              "System.Process"
              "readCreateProcessWithExitCode"
              "Use System.Process.Typed.readProcess instead for type-safe output capture."
          , Builder.restrictInModule
              "System.Process"
              "waitForProcess"
              "Use System.Process.Typed.waitExitCode instead for MonadIO support."
          , Builder.restrictInModule
              "System.Process"
              "getProcessExitCode"
              "Use System.Process.Typed.getExitCode instead for MonadIO support."
          , Builder.restrictInModule
              "System.Process"
              "terminateProcess"
              "Use System.Process.Typed.stopProcess instead for proper cleanup."
          , Builder.restrictInModule
              "System.Process"
              "interruptProcessGroupOf"
              "Consider using System.Process.Typed with setCreateGroup for process group management."
          , Builder.restrictInModule
              "System.Process"
              "runCommand"
              "Use System.Process.Typed.runProcess with shell instead for type-safe process execution."
          , Builder.restrictInModule
              "System.Process"
              "runProcess"
              "Use System.Process.Typed.runProcess instead for type-safe process execution."
          , Builder.restrictInModule
              "System.Process"
              "runInteractiveCommand"
              "Use System.Process.Typed.startProcess with shell and createPipe instead."
          , Builder.restrictInModule
              "System.Process"
              "runInteractiveProcess"
              "Use System.Process.Typed.startProcess with createPipe instead."
          , Builder.restrictInModule
              "System.Process"
              "system"
              "Use System.Process.Typed.runProcess with shell instead for type-safe process execution."
          , Builder.restrictInModule
              "System.Process"
              "rawSystem"
              "Use System.Process.Typed.runProcess instead for type-safe process execution."
          , Builder.restrictInModule
              "System.Process"
              "proc"
              "Use System.Process.Typed.proc instead for type-safe ProcessConfig."
          , Builder.restrictInModule
              "System.Process"
              "shell"
              "Use System.Process.Typed.shell instead for type-safe ProcessConfig."
          , Builder.restrictInModule
              "System.Process"
              "withCreateProcess"
              "Use System.Process.Typed.withProcessWait or withProcessTerm instead for MonadUnliftIO support."
          , Builder.restrictInModule
              "System.Process"
              "withCreateProcess_"
              "Use System.Process.Typed.withProcessWait_ or withProcessTerm_ instead for MonadUnliftIO support."
          ]
      ]

in  rules
