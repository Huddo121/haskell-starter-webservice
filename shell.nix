let
  config = (import ./config.nix);
in with config; hpkgs.shellFor {
  packages = p: [drv];
  buildInputs = with nixpkgs; [ hie cabal2nix cabal-install hlint hpkgs.ghcid hpkgs.stylish-haskell hpkgs.hasktags hpkgs.hoogle ];
}
