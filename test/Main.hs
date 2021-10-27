module Main where

import qualified Specs
import System.Environment (lookupEnv)
import Test.HSpec.JUnit (configWith)
import Test.Hspec.Runner
import Control.Monad (when)
import Data.Maybe (isJust)
import System.IO (hPutStrLn, stderr)

main :: IO ()
main = do
  ci <- lookupEnv "CI"

  let isOnCI = case ci of
        Just v | v == "1" || v == "true" -> True
        _ -> False
      config = if isOnCI then ciConfig else localConfig

  hPutStrLn stderr $ maybe "CI EnvVar not set" (\val -> "EnvVar CI=" ++ val) ci
  when isOnCI $ hPutStrLn stderr "Running with CI config"

  hspecWith ciConfig Specs.spec

-- | Configuration used when we detect that we're running in CI. Will produce a junit XML test report,
--     which should allow most CI systems to display more detailed test run information in their UI.
ciConfig :: Config
ciConfig = configWith "./test-reports/test-results.xml" "Haskell test suite" defaultConfig

localConfig :: Config
localConfig = defaultConfig {configColorMode = ColorAlways}
