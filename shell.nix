let
  config = (import ./config.nix);
in with config; hpkgs.shellFor {
  packages = p: [drv];
  # You can add any tools here that you would like to be available within a nix-shell. Hakell-Ide-Engine is started within
  #  a nix-shell automatically in VS-Code.
  buildInputs = with nixpkgs; [ haskellLanguageServer cabal-install hlint hpkgs.ghcid hpkgs.hasktags hpkgs.hoogle ];
}
