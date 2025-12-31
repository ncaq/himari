-- unliftio優先ルール
let Types = ../Types.dhall

let Builder = ../Builder.dhall

let unliftio = "for MonadUnliftIO support."

let monadio = "for MonadIO support."

let asyncFuncs =
      [ "async"
      , "asyncBound"
      , "asyncOn"
      , "asyncWithUnmask"
      , "withAsync"
      , "withAsyncBound"
      , "withAsyncOn"
      , "withAsyncWithUnmask"
      , "wait"
      , "poll"
      , "waitCatch"
      , "cancel"
      , "uninterruptibleCancel"
      , "cancelWith"
      , "race"
      , "race_"
      , "concurrently"
      , "concurrently_"
      , "mapConcurrently"
      , "forConcurrently"
      , "mapConcurrently_"
      , "forConcurrently_"
      , "replicateConcurrently"
      , "replicateConcurrently_"
      , "waitAny"
      , "waitAnyCatch"
      , "waitAnyCancel"
      , "waitAnyCatchCancel"
      , "waitEither"
      , "waitEitherCatch"
      , "waitEitherCancel"
      , "waitEitherCatchCancel"
      , "waitEither_"
      , "waitBoth"
      , "link"
      , "linkOnly"
      , "link2"
      , "link2Only"
      ]

let exceptionFuncs =
      [ "catch"
      , "catchJust"
      , "handle"
      , "handleJust"
      , "try"
      , "tryJust"
      , "bracket"
      , "bracket_"
      , "bracketOnError"
      , "finally"
      , "onException"
      , "mask"
      , "mask_"
      , "uninterruptibleMask"
      , "uninterruptibleMask_"
      , "evaluate"
      ]

let mvarFuncs =
      [ "withMVar"
      , "withMVarMasked"
      , "modifyMVar"
      , "modifyMVar_"
      , "modifyMVarMasked"
      , "modifyMVarMasked_"
      ]

let tempFuncs =
      [ "withSystemTempFile"
      , "withSystemTempDirectory"
      , "withTempFile"
      , "withTempDirectory"
      ]

let stmFuncs =
      [ "atomically"
      , "newTVarIO"
      , "readTVarIO"
      , "registerDelay"
      , "mkWeakTVar"
      , "newTMVarIO"
      , "newEmptyTMVarIO"
      , "mkWeakTMVar"
      , "newTChanIO"
      , "newBroadcastTChanIO"
      , "newTQueueIO"
      , "newTBQueueIO"
      ]

let ioFuncs =
      [ "withFile"
      , "withBinaryFile"
      , "openFile"
      , "hClose"
      , "hFlush"
      , "hFileSize"
      , "hSetFileSize"
      , "hIsEOF"
      , "hSetBuffering"
      , "hGetBuffering"
      , "hSeek"
      , "hTell"
      , "hIsOpen"
      , "hIsClosed"
      , "hIsReadable"
      , "hIsWritable"
      , "hIsSeekable"
      , "hIsTerminalDevice"
      , "hSetEcho"
      , "hGetEcho"
      , "hWaitForInput"
      , "hReady"
      ]

let iorefFuncs =
      [ "newIORef"
      , "readIORef"
      , "writeIORef"
      , "modifyIORef"
      , "modifyIORef'"
      , "atomicModifyIORef"
      , "atomicModifyIORef'"
      , "mkWeakIORef"
      ]

let chanFuncs =
      [ "newChan"
      , "writeChan"
      , "readChan"
      , "dupChan"
      , "getChanContents"
      , "writeList2Chan"
      ]

let qsemFuncs = [ "newQSem", "waitQSem", "signalQSem" ]

let qsemnFuncs = [ "newQSemN", "waitQSemN", "signalQSemN" ]

let directoryFuncs =
      [ "createDirectory"
      , "createDirectoryIfMissing"
      , "createFileLink"
      , "createDirectoryLink"
      , "removeDirectoryLink"
      , "getSymbolicLinkTarget"
      , "removeDirectory"
      , "removeDirectoryRecursive"
      , "removePathForcibly"
      , "renameDirectory"
      , "listDirectory"
      , "getDirectoryContents"
      , "getCurrentDirectory"
      , "setCurrentDirectory"
      , "withCurrentDirectory"
      , "getHomeDirectory"
      , "getXdgDirectory"
      , "getXdgDirectoryList"
      , "getAppUserDataDirectory"
      , "getUserDocumentsDirectory"
      , "getTemporaryDirectory"
      , "removeFile"
      , "renameFile"
      , "renamePath"
      , "copyFile"
      , "copyFileWithMetadata"
      , "canonicalizePath"
      , "makeAbsolute"
      , "makeRelativeToCurrentDirectory"
      , "findExecutable"
      , "findExecutables"
      , "findExecutablesInDirectories"
      , "findFile"
      , "findFiles"
      , "findFileWith"
      , "findFilesWith"
      , "getFileSize"
      , "doesPathExist"
      , "doesFileExist"
      , "doesDirectoryExist"
      , "pathIsSymbolicLink"
      , "getPermissions"
      , "setPermissions"
      , "copyPermissions"
      , "getAccessTime"
      , "getModificationTime"
      , "setAccessTime"
      , "setModificationTime"
      ]

let foreignCStringFuncs =
      [ "peekCString"
      , "peekCStringLen"
      , "newCString"
      , "newCStringLen"
      , "withCString"
      , "withCStringLen"
      , "peekCAString"
      , "peekCAStringLen"
      , "newCAString"
      , "newCAStringLen"
      , "withCAString"
      , "withCAStringLen"
      ]

let foreignCErrorFuncs =
      [ "throwErrno"
      , "throwErrnoIf"
      , "throwErrnoIf_"
      , "throwErrnoIfRetry"
      , "throwErrnoIfRetry_"
      , "throwErrnoIfMinus1"
      , "throwErrnoIfMinus1_"
      , "throwErrnoIfMinus1Retry"
      , "throwErrnoIfMinus1Retry_"
      , "throwErrnoIfNull"
      , "throwErrnoIfNullRetry"
      , "throwErrnoIfRetryMayBlock"
      , "throwErrnoIfRetryMayBlock_"
      , "throwErrnoIfMinus1RetryMayBlock"
      , "throwErrnoIfMinus1RetryMayBlock_"
      , "throwErrnoIfNullRetryMayBlock"
      , "throwErrnoPath"
      , "throwErrnoPathIf"
      , "throwErrnoPathIf_"
      , "throwErrnoPathIfNull"
      , "throwErrnoPathIfMinus1"
      , "throwErrnoPathIfMinus1_"
      ]

let foreignStorableFuncs =
      [ "peek"
      , "poke"
      , "peekByteOff"
      , "pokeByteOff"
      , "peekElemOff"
      , "pokeElemOff"
      ]

let foreignMarshalAllocFuncs =
      [ "alloca"
      , "allocaBytes"
      , "allocaBytesAligned"
      , "malloc"
      , "mallocBytes"
      , "calloc"
      , "callocBytes"
      , "realloc"
      , "reallocBytes"
      , "free"
      , "finalizerFree"
      ]

let foreignMarshalArrayFuncs =
      [ "peekArray"
      , "peekArray0"
      , "pokeArray"
      , "pokeArray0"
      , "newArray"
      , "newArray0"
      , "withArray"
      , "withArray0"
      , "withArrayLen"
      , "withArrayLen0"
      , "copyArray"
      , "moveArray"
      , "lengthArray0"
      , "allocaArray"
      , "allocaArray0"
      , "mallocArray"
      , "mallocArray0"
      , "callocArray"
      , "callocArray0"
      , "reallocArray"
      , "reallocArray0"
      ]

let foreignMarshalUtilsFuncs =
      [ "with"
      , "new"
      , "fromBool"
      , "toBool"
      , "maybeNew"
      , "maybeWith"
      , "maybePeek"
      , "withMany"
      , "copyBytes"
      , "moveBytes"
      , "fillBytes"
      ]

let foreignMarshalPoolFuncs =
      [ "withPool"
      , "pooledMalloc"
      , "pooledMallocBytes"
      , "pooledRealloc"
      , "pooledReallocBytes"
      , "pooledMallocArray"
      , "pooledMallocArray0"
      , "pooledReallocArray"
      , "pooledReallocArray0"
      , "pooledNew"
      , "pooledNewArray"
      , "pooledNewArray0"
      ]

let foreignForeignPtrFuncs =
      [ "newForeignPtr"
      , "newForeignPtr_"
      , "addForeignPtrFinalizer"
      , "withForeignPtr"
      , "finalizeForeignPtr"
      , "touchForeignPtr"
      , "mallocForeignPtr"
      , "mallocForeignPtrBytes"
      , "mallocForeignPtrArray"
      , "mallocForeignPtrArray0"
      , "newGHCForeignPtr"
      , "addGHCForeignPtrFinalizer"
      ]

let foreignStablePtrFuncs =
      [ "newStablePtr", "deRefStablePtr", "freeStablePtr" ]

let untypedExceptionFuncs =
      [ Builder.restrictInModule
          "UnliftIO.Exception"
          "throwString"
          "Use typed exceptions instead. Define a proper exception type."
      , Builder.restrictInModule
          "UnliftIO.Exception"
          "stringException"
          "Use typed exceptions instead. Define a proper exception type."
      ]

let rules
    : List Types.Rule
    = [ Builder.functions untypedExceptionFuncs
      , Builder.functions
          ( Builder.preferModule
              "Control.Concurrent.Async"
              "UnliftIO.Async"
              unliftio
              asyncFuncs
          )
      , Builder.functions
          ( Builder.preferModule
              "Control.Exception"
              "UnliftIO.Exception"
              unliftio
              exceptionFuncs
          )
      , Builder.functions
          ( Builder.preferModule
              "Control.Concurrent.MVar"
              "UnliftIO.MVar"
              unliftio
              mvarFuncs
          )
      , Builder.functions
          ( Builder.preferModule
              "System.Timeout"
              "UnliftIO.Timeout"
              unliftio
              [ "timeout" ]
          )
      , Builder.functions
          ( Builder.preferModule
              "System.IO.Temp"
              "UnliftIO.Temporary"
              unliftio
              tempFuncs
          )
      , Builder.functions
          ( Builder.preferModule
              "Control.Concurrent.STM"
              "UnliftIO.STM"
              monadio
              stmFuncs
          )
      , Builder.functions
          (Builder.preferModule "System.IO" "UnliftIO.IO" monadio ioFuncs)
      , Builder.functions
          ( Builder.preferModule
              "Data.IORef"
              "UnliftIO.IORef"
              monadio
              iorefFuncs
          )
      , Builder.functions
          ( Builder.preferModule
              "Control.Concurrent.Chan"
              "UnliftIO.Chan"
              monadio
              chanFuncs
          )
      , Builder.functions
          ( Builder.preferModule
              "Control.Concurrent.QSem"
              "UnliftIO.QSem"
              monadio
              qsemFuncs
          )
      , Builder.functions
          ( Builder.preferModule
              "Control.Concurrent.QSemN"
              "UnliftIO.QSemN"
              monadio
              qsemnFuncs
          )
      , Builder.functions
          ( Builder.preferModule
              "System.Directory"
              "UnliftIO.Directory"
              monadio
              directoryFuncs
          )
      , Builder.functions
          ( Builder.preferModule
              "Foreign.C.String"
              "UnliftIO.Foreign"
              monadio
              foreignCStringFuncs
          )
      , Builder.functions
          ( Builder.preferModule
              "Foreign.C.Error"
              "UnliftIO.Foreign"
              monadio
              foreignCErrorFuncs
          )
      , Builder.functions
          ( Builder.preferModule
              "Foreign.Storable"
              "UnliftIO.Foreign"
              monadio
              foreignStorableFuncs
          )
      , Builder.functions
          ( Builder.preferModule
              "Foreign.Marshal.Alloc"
              "UnliftIO.Foreign"
              monadio
              foreignMarshalAllocFuncs
          )
      , Builder.functions
          ( Builder.preferModule
              "Foreign.Marshal.Array"
              "UnliftIO.Foreign"
              monadio
              foreignMarshalArrayFuncs
          )
      , Builder.functions
          ( Builder.preferModule
              "Foreign.Marshal.Utils"
              "UnliftIO.Foreign"
              monadio
              foreignMarshalUtilsFuncs
          )
      , Builder.functions
          ( Builder.preferModule
              "Foreign.Marshal.Pool"
              "UnliftIO.Foreign"
              monadio
              foreignMarshalPoolFuncs
          )
      , Builder.functions
          ( Builder.preferModule
              "Foreign.ForeignPtr"
              "UnliftIO.Foreign"
              monadio
              foreignForeignPtrFuncs
          )
      , Builder.functions
          ( Builder.preferModule
              "Foreign.StablePtr"
              "UnliftIO.Foreign"
              monadio
              foreignStablePtrFuncs
          )
      ]

in  rules
