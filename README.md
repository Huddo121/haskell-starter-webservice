# Haskell-Starter-WebService

A starter for building out haskell web services. The goal of this starter is to give you something to build on top of,
with some of the fiddly bits taken care of for you, while providing a featureful and robust build and dev loop.

## Features

* Nix based build and dev environment
  * **NB:** [Adding the `all-hies` cache to your nix configuration](https://github.com/Infinisil/all-hies#cached-builds) is strongly recommended, using [cachix](https://github.com/cachix/cachix) you can run `cachix use all-hies` to get set up.
* Lots of tooling! 🔨
  * [Haskell-Ide-Engine](https://github.com/haskell/haskell-ide-engine), and VS-Code integration, just install the [Haskell Language Server extension](https://marketplace.visualstudio.com/items?itemName=alanz.vscode-hie-server)
  * [GHCiD](https://github.com/ndmitchell/ghcid)
  * [Hoogle](https://github.com/ndmitchell/hoogle)
  * [And more!](shell.nix)

## Using This Starter

1. Fork this repo
1. If you're on macOS or Linux, you can call `./bin/rename-things my-awesome-ws`
    * If you're running another operating system you can manually replace "haskell-starter-webservice" in the following places
        * config.nix
        * default.nix
        * haskell-starter-webservice.cabal
        * haskell-starter-webservice.nix
        * README.md
    * You will also need to rename the following files
        * haskell-starter-webservice.cabal -> my-awesome-ws.cabal
        * haskell-starter-webservice.nix -> my-awesome-ws.nix
1. Update your name and email in your project's freshly-renamed .cabal file
1. Run `nix-build` to ensure you renamed everything
1. Remove this introductory set of instructions and `bin/rename-things`
1. Build somethine awesome! 🚀

## Building This Project

This project uses [Nix](https://nixos.org/nix/) for its builds.

You can build your project using `nix build`, your build outputs will be in the `result` directory.

## Running the Server

Once you have built the server, you can run `./result/bin/haskell-starter-webservice`.

## Documentation Server

This project is able to serve swagger docs that are derived from the types of your routes and APIs. To start serving the
swagger-ui, run `nix-build`, then `./result/bin/docserver`. Swagger-ui will start running on
http://localhost:8443/swagger-ui.

## Continuous Integration

Basic configuration is included for the following CI providers:

* [Bitbucket Pipelines](https://bitbucket.org/product/features/pipelines): [bitbucket-pipelines.yml](bitbucket-pipelines.yml)
* [CircleCI](https://circleci.com): [.circleci/config.yml](.circleci/config.yml)
* [GitLab CI/CD](https://about.gitlab.com/product/continuous-integration/): [gitlab-ci.yml](.gitlab-ci.yml)
* [TravisCI](https://travis-ci.org/): [.travis.yml](.travis.yml)


## Documentation

* [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
* [Runbook](docs/RUNBOOK.md)
