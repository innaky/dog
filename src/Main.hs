module Main where

import System.Environment
import System.Directory
import System.IO
import Data.List

key :: [(String, [String] -> IO ())]
key = [("add", add)
      , ("remove", remove)
      , ("cat", fusFiles)]
      
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

twoHandles :: Handle -> Handle -> Handle -> IO ()
twoHandles firstH secondH outH = do
  end <-hIsEOF firstH
  if end
    then return ()
    else do fLine <- hGetLine firstH
            sLine <- hGetLine secondH
            let fusionLines = fLine ++ " " ++ sLine
            hPutStrLn outH fusionLines
            twoHandles firstH secondH outH

fusFiles :: [String] -> IO ()
fusFiles [firstFile, secondFile, outFile] = do
  firstHandle <- openFile firstFile ReadMode
  secondHandle <- openFile secondFile ReadMode
  outHandle <- openFile outFile WriteMode
  twoHandles firstHandle secondHandle outHandle
  hClose firstHandle
  hClose secondHandle
  hClose outHandle
            
main :: IO ()
main = do
  (cmd:args) <- getArgs
  let (Just call) = lookup cmd key
  call args
