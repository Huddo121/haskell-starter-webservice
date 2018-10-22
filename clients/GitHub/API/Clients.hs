module GitHub.API.Clients where

import GitHub.API
import Network.HTTP.Client (newManager, managerModifyRequest, requestHeaders, Request)
import Network.HTTP.Client.TLS (tlsManagerSettings)
import Network.HTTP.Types.Header
import Servant
import Servant.API
import Servant.Client

repositoryAPI :: Proxy RepositoryAPI
repositoryAPI = Proxy

myClient :: UserName -> RepositoryName -> ClientM Repository
myClient = client repositoryAPI

getMyRepo :: ClientM Repository
getMyRepo = do
  let user = UserName "huddo121"
      repo = RepositoryName "haskell-starter-webservice"
  myClient user repo

-- The GitHub API requires that we set *some* sort of UserAgent header
addUserAgent :: Request -> IO Request
addUserAgent req = pure req { requestHeaders = [(hUserAgent, "http-client-tls")] }

doTheThing = do
  let baseUrl = BaseUrl Https "api.github.com" 443 ""
  manager <- newManager tlsManagerSettings { managerModifyRequest = addUserAgent }
  putStrLn $ "Calling " ++ showBaseUrl baseUrl
  res <- runClientM getMyRepo (mkClientEnv manager baseUrl)
  case res of
    Left err -> putStrLn $ "Error: " ++ show err
    Right repo -> print repo
