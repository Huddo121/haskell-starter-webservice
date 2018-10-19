{ mkDerivation, aeson, base, lens, servant-docs, servant-server
, servant-swagger, servant-swagger-ui, stdenv, swagger2, warp
}:
mkDerivation {
  pname = "haskell-starter-webservice";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ aeson base servant-server ];
  executableHaskellDepends = [
    base lens servant-docs servant-server servant-swagger
    servant-swagger-ui swagger2 warp
  ];
  description = "A simple webservice";
  license = stdenv.lib.licenses.mit;
}
