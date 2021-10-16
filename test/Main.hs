module Main where

import qualified Specs
import System.Environment (lookupEnv)
import Test.HSpec.JUnit
import Test.Hspec.Runner

main :: IO ()
main = do
  ci <- lookupEnv "CI"
  let config = case ci of
        Just v | v == "1" -> ciConfig
        _ -> localConfig
  hspecWith config Specs.spec

-- | Configuration used when we detect that we're running in CI. Will produce a junit XML test report,
--     which should allow most CI systems to display more detailed test run information in their UI.
ciConfig :: Config
ciConfig =
  defaultConfig
    { configFormat = Just $ junitFormat "./test-reports/test-results.xml" "Haskell test suite"
    }

localConfig :: Config
localConfig = defaultConfig {configColorMode = ColorAlways}
