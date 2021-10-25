{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}

module App where

import API
  ( API,
    CheckFruitRequest (fruitName, fruitType),
    CheckFruitResponse (CheckFruitResponse, correct, delicious),
    FruitAPI,
    FruitName (Apple, Banana, Cherry, Watermelon),
    FruitType (Berry, Drupe, Fruit),
    Greeting (Greeting),
    GreetingAPI,
    api, -- Root level API that re-exports its child APIs
  )
import Control.Monad.IO.Class (liftIO)
import GitHub.API (Repository (..), RepositoryName (..), UserName (..))
import GitHub.API.Clients
import Network.Wai.Handler.Warp
import Servant (Application, Server, serve, type (:<|>) ((:<|>)))
import Data.Either (fromRight)

-- | Create handlers for serving our API
greetingHandler :: Server GreetingAPI
greetingHandler name = do
  forkMsg <- liftIO $ do
    res <- mkGitHubRequest $ getHaskellStarterRepo (UserName name)
    print res
    -- Check if the given repository has a parent with the ID matching the main haskell-starter-webservice repo
    let nonForkedMessage = "@" ++ name ++ " hasn't forked the repo on GitHub."
        hasForkedMessage = "@" ++ name ++ " has forked the repo!"
        forkMessage = (\repo -> if 153277456 `elem` (repositoryId <$> repositoryParent repo) then hasForkedMessage else nonForkedMessage) <$> res
    pure $ fromRight nonForkedMessage forkMessage
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
