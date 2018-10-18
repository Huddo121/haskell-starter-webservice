{-# LANGUAGE DeriveAnyClass #-}

module Greeting.API where

import Data.Aeson
import GHC.Generics
import Servant

type GreetingAPI = Capture "name" String :> Get '[JSON] Greeting

newtype Greeting = Greeting {
  greeting :: String
} deriving (Eq, Show, Generic, FromJSON, ToJSON)


