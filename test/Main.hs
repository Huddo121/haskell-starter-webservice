module Main where

import qualified Specs
import System.Environment (lookupEnv)
import Test.HSpec.JUnit (configWith, runJUnitSpec)
import Test.Hspec.Runner
import Control.Monad (when, void)
import Data.Maybe (isJust)
import System.IO (hPutStrLn, stderr)
import Test.Hspec

main :: IO ()
main = do
  ci <- lookupEnv "CI"

  let isOnCI = case ci of
        Just v | v == "1" || v == "true" -> True
        _ -> False
      testRun = if isOnCI then ciTestRun else localTestRun

  hPutStrLn stderr $ maybe "CI EnvVar not set" (\val -> "EnvVar CI=" ++ val) ci
  when isOnCI $ hPutStrLn stderr "Running with CI config"

  testRun Specs.spec

-- | Configuration used when we detect that we're running in CI. Will produce a junit XML test report,
--     which should allow most CI systems to display more detailed test run information in their UI.
ciTestRun :: Spec -> IO ()
ciTestRun spec = void $ runJUnitSpec spec ("./test-reports", "unit-tests") defaultConfig

localTestRun :: Spec -> IO ()
localTestRun spec = hspecWith (defaultConfig {configColorMode = ColorAlways}) spec
