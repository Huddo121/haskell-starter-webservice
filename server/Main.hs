{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds #-}

module Main where

import Fruit.API
import Greeting.API
import Network.Wai.Handler.Warp
import Servant

-- Combine all the APIs we want to serve
type API = "fruit" :> FruitAPI :<|> "greeting" :> GreetingAPI

api :: Proxy API
api = Proxy

-- Glue together all of our handlers
handlers :: Server API
handlers = fruitHandler :<|> greetingHandler

application :: Application
application = serve api handlers

main :: IO ()
main = do
  putStrLn "Starting the haskell-starter-webservice!"
  run 8081 application



greetingHandler :: Server GreetingAPI
greetingHandler name = pure $ Greeting $ "Hi " ++ show name ++ "!"

fruitHandler :: Server FruitAPI
fruitHandler request = case (fruitName request, fruitType request) of
                  (Apple, Fruit)      -> pure $ CheckFruitResponse { delicious = True,   correct = True  }
                  (Banana, Berry)     -> pure $ CheckFruitResponse { delicious = True,   correct = True  }
                  (Cherry, Drupe)     -> pure $ CheckFruitResponse { delicious = False,  correct = True  }
                  (Watermelon, Berry) -> pure $ CheckFruitResponse { delicious = True,   correct = True  }
                  _                   -> pure $ CheckFruitResponse { delicious = False,  correct = False }

