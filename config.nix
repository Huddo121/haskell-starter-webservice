rec {
  # Which version of GHC does the project need to be built with? This must exist in both nixpkgs, and hie-nix
  ghcVersion = "ghc865";
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
    nixpkgs = {
      owner = "NixOs";
      repo = "nixpkgs";
      rev = "27c3d36";
      sha256 = "0kaazqda1saaasyd2dg3zz2zwag36555x981znplq4fq85brval5";
    };

    all-hies = {
      owner = "Infinisil";
      repo = "all-hies";
      rev = "9214868";
      sha256 = "1yb75f8p09dp4yx5d3w3wvdiflaav9a5202xz9whigk2p9ndwbp5";
    };
  };

  # Our custom copy of nixpkgs, with our project's package injected in to the set of haskellPackages
  nixpkgs = import (fetchFromGitHub repos.nixpkgs) {
    config = {
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

  # Pick a version of HIE that is compatible with our version of GHC.
  hie = (import (fetchFromGitHub repos.all-hies) { }).versions.${ghcVersion};
}
