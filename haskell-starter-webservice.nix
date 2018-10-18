{ mkDerivation, aeson, base, servant-server, stdenv, warp }:
mkDerivation {
  pname = "haskell-starter-webservice";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ aeson base servant-server ];
  executableHaskellDepends = [ base servant-server warp ];
  description = "A simple webservice";
  license = stdenv.lib.licenses.mit;
}
