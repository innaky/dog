module Main where

import System.Environment
import System.Directory
import System.IO
import Data.List

key :: [(String, [String] -> IO ())]
key = [("add", add)
      , ("remove", remove)]

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

main :: IO ()
main = do
  (cmd:args) <- getArgs
  let (Just call) = lookup cmd key
  call args
