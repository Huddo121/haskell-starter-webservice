module GitHub.API.Clients where

import GitHub.API
import Network.HTTP.Client (Request, managerModifyRequest, newManager, requestHeaders)
import Network.HTTP.Client.TLS (tlsManagerSettings)
import Network.HTTP.Types.Header
import Servant
import Servant.API
import Servant.Client

repositoryAPI :: Proxy RepositoryAPI
repositoryAPI = Proxy

getRepository :: UserName -> RepositoryName -> ClientM Repository
getRepository = client repositoryAPI

getHaskellStarterRepo :: UserName -> ClientM Repository
getHaskellStarterRepo username = do
  let repo = RepositoryName "haskell-starter-webservice"
  getRepository username repo

-- The GitHub API requires that we set *some* sort of UserAgent header
addUserAgent :: Request -> IO Request
addUserAgent req = pure req {requestHeaders = [(hUserAgent, "http-client-tls")]}

mkGitHubRequest :: (GitHubRequestable a) => ClientM a -> IO (Either ClientError a)
mkGitHubRequest req = do
  let baseUrl = BaseUrl Https "api.github.com" 443 ""
  manager <- newManager tlsManagerSettings {managerModifyRequest = addUserAgent}
  runClientM req (mkClientEnv manager baseUrl)
