{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import API
import Control.Lens
import           Data.Swagger
import Data.Swagger.Operation
import Network.Wai.Handler.Warp (run)
import Servant
import Servant.Docs
import Servant.Swagger
import Servant.Swagger.UI


-- Serve the swagger documentation
main :: IO ()
main = do
  putStrLn "Starting documentation server"
  run 8443 swaggerUIApp

swaggerDocs :: Swagger
swaggerDocs = toSwagger api
  & info.title        .~ "My Awesome WebService API"
  & info.version      .~ "ALPHA"
  & info.description  ?~ "This is my awesome API. I hope you like it!"

type SwaggerUIAPI = SwaggerSchemaUI "swagger-ui" "swagger.json"

swaggerUIAPI :: Proxy SwaggerUIAPI
swaggerUIAPI = Proxy

swaggerUIServer :: Server SwaggerUIAPI
swaggerUIServer = swaggerSchemaUIServer swaggerDocs

swaggerUIApp = serve swaggerUIAPI swaggerUIServer

-- A series of instances that we need to get our documentation to work
instance ToSchema CheckFruitRequest where
  declareNamedSchema proxy = genericDeclareNamedSchema defaultSchemaOptions proxy
        & mapped.schema.description ?~
          "Check that the given `fruitName` and `fruitType` match, and whether the fruit is delicious"

instance ToSchema CheckFruitResponse

instance ToSchema FruitName
instance ToSchema FruitType

instance ToSchema Greeting
