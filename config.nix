rec {
  ghcVersion = "ghc843";
  nixpkgs = import (fetchTarball https://github.com/NixOS/nixpkgs/tarball/a7fd4310c0cc7f50d2e5eb1f6172c31969569930) {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: rec {
        hPkgs = pkgs.haskell.packages.${ghcVersion};

        haskellPackages = hPkgs.override {
          overrides = super: self: {
            haskell-starter-webservice = self.callPackage ./haskell-starter-webservice.nix { };
          };
        };
      };
    };
  };
  hie = import (fetchTarball https://github.com/domenkozar/hie-nix/tarball/96af698f0cfefdb4c3375fc199374856b88978dc) { pkgs=nixpkgs; };
}
