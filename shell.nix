{
  config ? import (./config.nix)
}:
with config.nixpkgs;
let
  # Import the package and all its dependencies
  package = (import ./.);

  hie = config.hie.hie84;

  hpkgs = haskell.packages.${config.ghcVersion};

  # Set up a shell environment with all those dependencies and more!
  shellEnvironment = package.env.overrideAttrs (originalAttrs: {
    buildInputs = originalAttrs.buildInputs ++ [ hie cabal2nix cabal-install hlint hpkgs.stylish-haskell hpkgs.hasktags hpkgs.hoogle ];
  });

in shellEnvironment
