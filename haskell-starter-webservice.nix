{ mkDerivation, base, stdenv }:
mkDerivation {
  pname = "haskell-starter-webservice";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base ];
  executableHaskellDepends = [ base ];
  doHaddock = false;
  description = "A simple webservice";
  license = stdenv.lib.licenses.mit;
}
