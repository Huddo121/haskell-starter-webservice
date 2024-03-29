module Specs.AppHandlerSpec where

import App (fruitHandler)
import qualified App
import Control.Concurrent.MVar
import Control.Exception (bracket)
import Data.Aeson
import Data.ByteString
import Data.Proxy (Proxy (Proxy))
import Fruit.API
import Network.HTTP.Client (Request, defaultManagerSettings, newManager)
import Network.HTTP.Types
import qualified Network.Wai.Handler.Warp as Warp
import Network.Wai.Test (SResponse)
import Servant.Client
import Servant.Server (serve)
import Test.Hspec
import Test.Hspec.Wai
import Test.Hspec.Wai.Matcher

spec :: Spec
spec =
  do
    -- create a servant-client ClientEnv
    baseUrl <- runIO $ parseBaseUrl "http://localhost"
    manager <- runIO $ newManager defaultManagerSettings
    let clientEnv port = mkClientEnv manager (baseUrl {baseUrlPort = port})

    describe "App handlers" $ do
      describe "fruitHandler" $
        -- `around` will start the server, and then stop it once the tests complete
        around fruitServer $ do
          it "Apple is a delicious fruit" $ \port -> do
            result <- runClientM (checkFruit (CheckFruitRequest Apple Fruit)) (clientEnv port)
            result `shouldBe` (Right $ CheckFruitResponse {delicious = True, correct = True})
      -- Another way of writing tests that may feel more natural for some people
      with (pure $ serve fruitAPI fruitHandler) $ do
        it "Cherry is a drupe, but not delicious" $ do
          let response = postJSON "/" (CheckFruitRequest Cherry Drupe)
          response `shouldRespondWithJSON` 200 $ (CheckFruitResponse {delicious = False, correct = True})

shouldRespondWithJSON :: ToJSON a => WaiSession st SResponse -> ResponseMatcher -> a -> WaiExpectation st
shouldRespondWithJSON response expectedStatus expectedBody = response `shouldRespondWith` expectedStatus {matchBody = bodyEquals (encode expectedBody)}

postJSON :: ToJSON a => ByteString -> a -> WaiSession st SResponse
postJSON path body = request methodPost path [("Content-Type", "application/json")] (encode body)

fruitAPI :: Proxy FruitAPI
fruitAPI = Proxy :: Proxy FruitAPI

fruitServer :: (Warp.Port -> IO a) -> IO a
fruitServer = Warp.testWithApplication (pure $ serve fruitAPI fruitHandler)

-- A client that will be used to make the requests, generated by servant-client
checkFruit :: CheckFruitRequest -> ClientM CheckFruitResponse
checkFruit = client fruitAPI
