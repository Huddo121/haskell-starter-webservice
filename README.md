# Haskell-Starter-WebService

A starter for building out haskell web services. The goal of this starter is to give you something to build on top of,
with some of the fiddly bits taken care of for you, while providing a featureful and robust build and dev loop.

## Using This Starter

1. Fork this repo
1. Rename occurrences of haskell-starter-webservice to something more specific to your use case.
   * haskell-starter-webservice.nix (filename and contents)
   * haskell-starter-webservice.cabal (filename and contents)
   * config.nix (contents)
   * default.nix (contents)
   * src/Main.hs (contents)
   * bin/update-derivation
1. Remove this introductory set of instructions
1. Run `nix-build` to ensure you renamed everything
1. Push your repo to its new home! 🚀

## Building This Project

This project uses [Nix](https://nixos.org/nix/) for its builds.

`nix build`

## Running the Server

Once you have built the server, you can run `./result/bin/my-awesome-ws`.

## Documentation Server

This project is able to serve swagger docs that are derived from the types of your routes and APIs. To start serving the
swagger-ui, run `nix-build`, then `./result/bin/docserver`. Swagger-ui will start running on
http://localhost:8443/swagger-ui.

## Documentation

* [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
* [Runbook](docs/RUNBOOK.md)
