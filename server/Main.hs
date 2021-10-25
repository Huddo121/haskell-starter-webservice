module Main where

import App
import Network.Wai.Handler.Warp

main :: IO ()
main = do
  putStrLn "Starting the application on port 8081"
  run 8081 application
