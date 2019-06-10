# Runbook

## Overview

Because we're using Nix, it's possible that some tooling that you expect to work, will not work right out of the box.

A `shell.nix` file is included, which allows you to drop in to an environment that contains most of what you need to work on this project, including development tooling. This can be activated using `nix-shell`.

This can take a **very long** time to complete when you first run it, you might want to go grab a coffee. ☕️

We can try to combat this by using binary caches as much as possible. The project we use to pull down the right version of haskell-ide-engine is called [all-hies](https://github.com/Infinisil/all-hies), and it has its own binary cache. You can set this up following [their instructions](https://github.com/Infinisil/all-hies#cached-builds), which uses [cachix](https://github.com/cachix/cachix), or you can manually update your nix configuration to include the following;

```
substituters = https://all-hies.cachix.org https://cache.nixos.org/
trusted-public-keys = all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
```

The officially supported IDE for this project is [VS Code](https://code.visualstudio.com/), with the latest version of the [Haskell IDE Engine](https://marketplace.visualstudio.com/items?itemName=alanz.vscode-hie-server) plugin.

Due to the workspace settings used, Haskell IDE Engine will be started automatically when you open a Haskell file in this project. Setting up the nix environment takes a little bit of time, so don't panic if it takes 10-30 seconds of wait time before type annotations start appearing.

If you would like a faster way of verifying that the project is building correctly, you can drop in to a nix-shell (or if you have Cabal installed globally, it will [automatically use the nix-shell for you](https://cabal.readthedocs.io/en/latest/nix-integration.html)) and run `cabal repl <target>`.


## Common Tasks

### I Want To Add a New Dependency, or Update an Existing One

Update the .cabal file with your new dependencies, as you would for any regular cabal project, however, **do not** add version bounds. The `nixpkgs` repository stores all of our dependencies, but it is a curated selection, not all versions of dependencies are available all the time.

### I Need a Different Version of a Dependency Than What's in Nixpkgs

If it's a haskell package, we can just create a new derivation pointing to the newer (or older) version of the package. In `config.nix` we specify some package overrides to inject our own project in to the list of dependencies, we can do the same for other dependencies too!

If you find the package you want on hackage, you can run `cabal2nix cabal://monad-persist > monad-persist.nix`, and then add a call to the new expression in the overrides.

```
haskellPackages = hPkgs.override {
  overrides = super: self: {
    my-awesome-ws = self.callPackage ./my-awesome-ws.nix { };
    monad-persist = self.callPackage ./monad-persist.nix { };
  };
};
```
