module GitHub.API where

import Data.Aeson
import Data.Aeson.Casing
import Data.Text (pack, unpack)
import GHC.Generics
import Servant


type RepositoryAPI = "repos" :> Capture "owner" UserName :> Capture "repository" RepositoryName :> Get '[JSON] Repository

ghJSONOptions = aesonPrefix snakeCase
snakeCaseOptions = defaultOptions { fieldLabelModifier = snakeCase }

data Repository = Repository {
  repositoryId :: Int,
  repositoryName :: RepositoryName,
  repositoryOwner :: RepositoryOwner,
  repositoryPrivate :: Bool,
  repositoryDescription :: String,
  repositoryLanguage :: ProgrammingLanguage,
  repositoryStargazersCount :: Int,
  repositoryWatchersCount :: Int,
  repositoryLicense :: License
} deriving (Eq, Show, Generic)

instance FromJSON Repository where
  parseJSON = genericParseJSON ghJSONOptions

instance ToJSON Repository where
  toJSON = genericToJSON snakeCaseOptions

newtype RepositoryName = RepositoryName String deriving (Eq, Show, Generic)
instance FromJSON RepositoryName
instance ToJSON RepositoryName

-- These instances need to exist for all types used as 'Captures' or 'QueryParam's
instance ToHttpApiData RepositoryName where
  toUrlPiece (RepositoryName s) = pack s
instance FromHttpApiData RepositoryName where
  parseUrlPiece t = Right $ RepositoryName $ unpack t

data RepositoryOwner = RepositoryOwner {
  repositoryOwnerlogin :: UserName,
  repositoryOwnerId :: Int,
  repositoryOwnerUrl :: String,
  repositoryOwnerAvatarUrl :: String,
  repositoryOwnerRepositoryType :: String
} deriving (Eq, Show, Generic)

instance FromJSON RepositoryOwner where
  parseJSON = genericParseJSON ghJSONOptions

instance ToJSON RepositoryOwner where
  toJSON = genericToJSON ghJSONOptions

newtype UserName = UserName String deriving (Eq, Show, Generic)
instance FromJSON UserName
instance ToJSON UserName
instance ToHttpApiData UserName where
  toUrlPiece (UserName s) = pack s
instance FromHttpApiData UserName where
  parseUrlPiece t = Right $ UserName $ unpack t


newtype ProgrammingLanguage = ProgrammingLanguage String deriving (Eq, Show, Generic)
instance FromJSON ProgrammingLanguage
instance ToJSON ProgrammingLanguage

data License = License {
  licenseKey :: String,
  licenseName :: String,
  licenseSpdxId :: String
} deriving (Eq, Show, Generic)

instance FromJSON License where
  parseJSON = genericParseJSON ghJSONOptions

instance ToJSON License where
  toJSON = genericToJSON ghJSONOptions
