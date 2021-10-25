{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}

module App where

import API -- Root level API that re-exports its child APIs
import Control.Monad.IO.Class (liftIO)
import GitHub.API (RepositoryName (..), UserName (..))
import GitHub.API.Clients
import Network.Wai.Handler.Warp
import Servant

-- | Create handlers for serving our API
greetingHandler :: Server GreetingAPI
greetingHandler name = do
  forkMsg <- liftIO $ do
    res <- mkGitHubRequest getHaskellStarterRepo
    print res
    pure $ either (const "You haven't forked the repo on GitHub.") (const "You forked the repo!") res
  pure $ Greeting $ "Hi " ++ show name ++ "! " ++ forkMsg

fruitHandler :: Server FruitAPI
fruitHandler request = case (fruitName request, fruitType request) of
  (Apple, Fruit) -> pure $ CheckFruitResponse {delicious = True, correct = True}
  (Banana, Berry) -> pure $ CheckFruitResponse {delicious = True, correct = True}
  (Cherry, Drupe) -> pure $ CheckFruitResponse {delicious = False, correct = True}
  (Watermelon, Berry) -> pure $ CheckFruitResponse {delicious = True, correct = True}
  _ -> pure $ CheckFruitResponse {delicious = False, correct = False}

-- Glue together all of our handlers
handlers :: Server API
handlers = fruitHandler :<|> greetingHandler

application :: Application
application = serve api handlers
