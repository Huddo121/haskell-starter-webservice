# Testing

This project is set up with a single test suite (see the `.cabal` file in the project root), with the test code residing in the `test` directory. [HSpec](https://hspec.github.io/) is used as the test runner and reporter. HSpec has been set up with some quality of life plugins, one which outputs test results in JUnit format so that CI servers can provide more useful test reporting (output will be in `/test-reports/test-results.xml`), and `hspec-discover` which will find the tests for you inside the `test` directory.

## Running the test suite

You can run the test suite using `cabal test` when you're inside a nix shell, or directly using `nix-shell --command "cabal test"`. The tests will also run during `nix-build`, though locally this will likely result in a lot of unnecessary recompilation.

## Writing tests

Take note of the rules that `hspec-discover` will use to find your tests:

* The file is within the `test` directory
* The file ends in 'Spec.hs'
* The module exports `spec :: Spec`
