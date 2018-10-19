module API (

  api,
  API,
  module Fruit.API,
  module Greeting.API

  ) where

import Fruit.API
import Greeting.API
import Servant

-- Combine all the APIs we want to serve
type API = "fruit" :> FruitAPI :<|> "greeting" :> GreetingAPI

api :: Proxy API
api = Proxy
