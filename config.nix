rec {
  # Which version of GHC does the project need to be built with? This must exist in both nixpkgs, and hie-nix
  ghcVersion = "ghc865";
  languageServerGHCVersion = "8.6.5";

  # Pick a release version from https://github.com/haskell/haskell-language-server/releases
  # Double check to make sure it's available in https://github.com/masaeedu/all-hls/blob/master/sources.json
  languageServerVersion = "0.4.0";

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

    all-hls = {
      owner = "masaeedu";
      repo = "all-hls";
      rev = "155e57d7ca9f79ce293360f98895e9bd68d12355";
      sha256 = "04s3mrxjdr7gmd901l1z23qglqmn8i39v7sdf2fv4zbv6hz24ydb";
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

  # Make sure we're getting the right version of the Haskell-Language server for our GHC version and our Operating System
  haskellLanguageServer = let
          platform = if builtins.currentSystem == "x86_64-darwin" then "MacOS" else "Linux";
        in (import (fetchFromGitHub repos.all-hls) {
          pkgs = nixpkgs;
          platform = platform;
          version = languageServerVersion;
          ghc = languageServerGHCVersion;
        });
}
