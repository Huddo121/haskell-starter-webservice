rec {
  # Which version of GHC does the project need to be built with? This must exist in both nixpkgs, and hie-nix
  ghcVersion = "ghc864";
  # This should be compatible with the above ghcVersion
  hieVersion = "hie86";
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
      rev = "5e7e5a2";
      sha256 = "1m1ic0wgr2y0qq6iglpav1ajh6zcx2x4hk2fhf1n0p0h73v3601p";
    };

    # The version of hie-nix we wish to include with the project
    hie-nix = {
      owner="domenkozar";
      repo="hie-nix";
      rev="922bbc7";
      sha256="1wf80g1zbgglc3lyqrzfdaqrzhdgmzhgg1p81hd2cpp57gpai9wh";
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

  # The version of haskell-ide-engine we are using
  hie = (import (fetchFromGitHub repos.hie-nix) { }).${hieVersion};
}
