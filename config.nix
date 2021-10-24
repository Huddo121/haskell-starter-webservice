rec {
  # Which version of GHC does the project need to be built with?
  ghcVersion = "ghc8107";

  # Bootstrap the ability to fetch from GitHub
  fetchFromGitHub = (import <nixpkgs> {}).fetchFromGitHub;

  # The set of haskellPackages we are working with. This lists packages that can be built with our specified
  #  version of GHC
  hpkgs = nixpkgs.haskell.packages.${ghcVersion};

  # Build up a nix expression for this project from the cabal file
  drv = nixpkgs.haskellPackages.callCabal2nix "haskell-starter-webservice" ./. {};

  # Repositories and commits that will be used in this build. Using specific commits and hashes increases
  #  the reproducibility and cacheability of builds.
  # In order to retrieve the hashes for these repos run
  #  nix-prefetch-url --unpack https://github.com/$OWNER/$REPO/archive/$REV.tar.gz
  repos = {
    # A specific commit of the nixpkgs repository we wish to build from, for maximum repeatability
    # nix-prefetch-url --unpack https://github.com/nixos/nixpkgs/archive/$REV.tar.gz
    nixpkgs = {
      owner = "NixOs";
      repo = "nixpkgs";
      rev = "6b23e8fc7820366e489377b5b00890f088f36a01";
      sha256 = "0jy86psfq0wbsjfcf5v1c2pswlz6yjpw7cypq9sy9b9pvgzd7720";
    };
  };

  # Our custom copy of nixpkgs, with our project's package injected in to the set of haskellPackages
  nixpkgs = import (fetchFromGitHub repos.nixpkgs) {
    config = {
      # If you choose a non-free license or add a non-free dependency, you may need to provide this config:
      # allowUnfree = true;
      packageOverrides = pkgs: rec {
        haskellPackages = hpkgs.override {
          overrides = super: self: {
            haskell-starter-webservice = drv;
          };
        };
      };
    };
  };

  haskellLanguageServer = hpkgs.haskell-language-server;
}
