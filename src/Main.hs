module Main where

import System.Environment
import System.Directory
import System.IO
import Data.List
import System.Directory.Tree (FileName)

key :: [(String, [String] -> IO ())]
key = [("add", add)
      , ("remove", remove)
      , ("cat", catFile)]

add :: [String] -> IO ()
add [fileName, input] = appendFile fileName (input ++ "\n")

remove :: [String] -> IO ()
remove [fileName, numberString] = do
  handle <- openFile fileName ReadMode
  (tempName, tempHandle) <- openTempFile "." "temp"
  contents <- hGetContents handle
  let number = read numberString
      tasks = lines contents
      newLines = delete (tasks !! number) tasks
  hPutStr tempHandle $ unlines newLines
  hClose handle
  hClose tempHandle
  removeFile fileName
  renameFile tempName fileName

twoHandles :: Handle -> Handle -> IO String
twoHandles firstH secondH = do
  end <-hIsEOF firstH
  if end
    then return $ "EOF"
    else do fLine <- hGetLine firstH
            sLine <- hGetLine secondH
            let fusionLines = fLine ++ " " ++ sLine
            return $ fusionLines
            twoHandles firstH secondH
            
catFile :: FilePath -> FilePath -> FileName -> IO ()
catFile firstFile secondFile outFile = do
  firstHandle <- openFile firstFile ReadMode
  secondHandle <- openFile secondFile ReadMode
  (tempName, tempHandle) <- openTempFile "." "temp"
  fusionLines <- twoHandles firstHandle secondHandle
  hPutStrLn tempHandle fusionLines
  hClose firstHandle
  hClose secondHandle
  hClose tempHandle
  renameFile tempName outFile

main :: IO ()
main = do
  (cmd:args) <- getArgs
  let (Just call) = lookup cmd key
  call args
