# Testing

This project is set up with a single test suite (see the `.cabal` file in the project root), with the test code residing in the `test` directory. [HSpec](https://hspec.github.io/) is used as the test runner and reporter, with [Hedgehog](https://hedgehog.qa/) used for property-based testing. HSpec has been set up with some quality of life plugins, one which outputs test results in JUnit format so that CI servers can provide more useful test reporting (output will be in `/test-reports/test-results.xml`), and `hspec-discover` which will find the tests for you inside the `test` directory.

## Running the test suite

You can run the test suite using `cabal test` when you're inside a nix shell, or directly using `nix-shell --command "cabal test"`. The tests will also run during `nix-build`, though locally this will likely result in a lot of unnecessary recompilation.

## Writing tests

Take note of the rules that `hspec-discover` will use to find your tests:

* The file is within the `test` directory
* The file ends in 'Spec.hs'
* The module exports `spec :: Spec`

## Property-based testing

Automated testing is an important part of building any production-grade service. Many developers resort to example-based testing for all of their unit and integration testing needs. An example-based test is one where you set up a situation, provide some manually crafted input, and assert something based on the result. Most often these assertions are very broad, and claim that the given situation occurs for all examples similar to the one provided, but beyond that single test this isn't checked.

Property-based testing on the other hand takes an approach where rather than providing a manually crafted example of an input, you use a propert-based testing library to generate inputs. Through your generators, you define the things you want to vary, and the things that should remain static or known, and use this to test that some _property_ holds.

### Extra resources

* [Time Travelling and Fixing Bugs with Property-Based Testing](https://wickstrom.tech/programming/2019/11/17/time-travelling-and-fixing-bugs-with-property-based-testing.html)
  * This blog post goes through the process of refining some tests for a property, and provides a great example of how you should be thinking when coming up with your own properties, and also covers some useful features that are available on most property-based testing libraries.
