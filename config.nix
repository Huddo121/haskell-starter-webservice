rec {
  ghcVersion = "ghc844";
  nixpkgs = import (fetchTarball https://github.com/NixOS/nixpkgs/tarball/c1acb5ce6d8472891d3748e86ac0ff0f17de4ed9) {
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
  hie = import (fetchTarball https://github.com/domenkozar/hie-nix/tarball/a270d8db4551f988437ac5db779a3cf614c4af68) { };
}
