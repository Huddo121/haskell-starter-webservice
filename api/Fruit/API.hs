{-# LANGUAGE DeriveAnyClass #-}

module Fruit.API where

import Data.Aeson
import GHC.Generics
import Servant

type FruitAPI = ReqBody '[JSON] CheckFruitRequest :> Post '[JSON] CheckFruitResponse

data CheckFruitRequest = CheckFruitRequest {
  fruitName :: FruitName,
  fruitType :: FruitType
} deriving (Eq, Show, Generic, FromJSON, ToJSON)

data CheckFruitResponse = CheckFruitResponse {
  delicious :: Bool,
  correct :: Bool
} deriving (Eq, Show, Generic, FromJSON, ToJSON)

data FruitName = Apple | Banana | Cherry | Watermelon deriving (Eq, Show, Generic, FromJSON, ToJSON)
data FruitType = Fruit | Berry | Drupe deriving (Eq, Show, Generic, FromJSON, ToJSON)
