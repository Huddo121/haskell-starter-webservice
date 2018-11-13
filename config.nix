rec {
  ghcVersion = "ghc843";
  nixpkgs = import (fetchTarball https://nixos.org/channels/nixos-18.09/nixexprs.tar.xz) {
    config = {
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
  hie = import (fetchTarball https://github.com/domenkozar/hie-nix/tarball/96af698f0cfefdb4c3375fc199374856b88978dc) { };
}
