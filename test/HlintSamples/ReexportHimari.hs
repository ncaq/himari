{-# OPTIONS_GHC -Wno-x-partial #-}

-- Sample file to test that hlint rules match symbols re-exported through Himari.
-- Everything is used through a plain `import Himari`, which is the primary way to use himari.
module HlintSamples.ReexportHimari where

import Himari

-- Data.List partial functions (should warn)
useHead :: [Int] -> Int
useHead = head

useTail :: [Int] -> [Int]
useTail = tail

useInit :: [Int] -> [Int]
useInit = init

useLast :: [Int] -> Int
useLast = last

useCycle :: [Int] -> [Int]
useCycle = cycle

useScanl1 :: [Int] -> [Int]
useScanl1 = scanl1 (+)

useScanr1 :: [Int] -> [Int]
useScanr1 = scanr1 (+)

-- Data.Foldable partial functions (should warn)
-- Data.List exports the very same entities, so the rules of both modules apply to them.
useFoldl1 :: [Int] -> Int
useFoldl1 = foldl1 (+)

useFoldr1 :: [Int] -> Int
useFoldr1 = foldr1 (+)

useMaximum :: [Int] -> Int
useMaximum = maximum

useMinimum :: [Int] -> Int
useMinimum = minimum

useMaximumBy :: [Int] -> Int
useMaximumBy = maximumBy (comparing negate)

useMinimumBy :: [Int] -> Int
useMinimumBy = minimumBy (comparing negate)

-- Data.Bifoldable partial functions (should warn)
useBifoldl1 :: (Int, Int) -> Int
useBifoldl1 = bifoldl1 (+)

useBifoldr1 :: (Int, Int) -> Int
useBifoldr1 = bifoldr1 (+)

useBimaximum :: (Int, Int) -> Int
useBimaximum = bimaximum

useBiminimum :: (Int, Int) -> Int
useBiminimum = biminimum

useBimaximumBy :: (Int, Int) -> Int
useBimaximumBy = bimaximumBy (comparing negate)

useBiminimumBy :: (Int, Int) -> Int
useBiminimumBy = biminimumBy (comparing negate)

-- Data.Maybe partial functions (should warn)
useFromJust :: Maybe Int -> Int
useFromJust = fromJust

-- System.IO String IO functions (should warn)
useGetChar :: IO Char
useGetChar = getChar

useGetLine :: IO String
useGetLine = getLine

useGetContents :: IO String
useGetContents = getContents

useInteract :: IO ()
useInteract = interact id

useReadIO :: IO Int
useReadIO = readIO "1"

useReadLn :: IO Int
useReadLn = readLn

usePutChar :: IO ()
usePutChar = putChar 'a'

usePutStr :: IO ()
usePutStr = putStr "a"

usePutStrLn :: IO ()
usePutStrLn = putStrLn "a"

usePrint :: IO ()
usePrint = print (1 :: Int)

useReadFile :: IO String
useReadFile = readFile "foo.txt"

useWriteFile :: IO ()
useWriteFile = writeFile "foo.txt" "a"

useAppendFile :: IO ()
useAppendFile = appendFile "foo.txt" "a"

-- Control.Lens.Traversal partial or unsafe functions (should warn)
useSingular :: [Int] -> Int
useSingular xs = xs ^. singular traverse

useUnsafeSingular :: [Int] -> Int
useUnsafeSingular xs = xs ^. unsafeSingular traverse

useUnsafePartsOf :: [Int] -> [Int]
useUnsafePartsOf xs = xs ^. unsafePartsOf traverse

useIunsafePartsOf :: [Int] -> [Int]
useIunsafePartsOf xs = xs ^. iunsafePartsOf traversed

-- UnliftIO.Exception string exceptions (should warn)
useThrowString :: IO ()
useThrowString = throwString "a"

useStringException :: StringException
useStringException = stringException "a"

-- Total alternatives (should NOT warn)
useHeadMay :: [Int] -> Maybe Int
useHeadMay = headMay

useFromMaybe :: Maybe Int -> Int
useFromMaybe = fromMaybe 0

-- Himari exports the UnliftIO versions of these names, which are the recommended ones.
-- The rules for the base versions of the same names must not apply to them (should NOT warn).
useCatch :: IO ()
useCatch = catch (pure ()) (\(_ :: IOException) -> pure ())

useBracket :: IO ()
useBracket = bracket (pure ()) (const (pure ())) (const (pure ()))

useFinally :: IO ()
useFinally = finally (pure ()) (pure ())

useTry :: IO (Either IOException ())
useTry = try (pure ())

useWithMVar :: MVar () -> IO ()
useWithMVar mv = withMVar mv pure

useModifyMVar :: MVar () -> IO ()
useModifyMVar mv = modifyMVar_ mv pure

useTimeout :: IO (Maybe ())
useTimeout = timeout 1000 (pure ())

useMyThreadId :: IO ThreadId
useMyThreadId = myThreadId

useDoesFileExist :: IO Bool
useDoesFileExist = doesFileExist "foo.txt"
