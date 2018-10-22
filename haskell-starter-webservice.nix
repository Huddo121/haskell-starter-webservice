{ mkDerivation, aeson, aeson-casing, base, http-client-tls, lens
, servant, servant-client, servant-docs, servant-server
, servant-swagger, servant-swagger-ui, stdenv, swagger2, text, warp
}:
mkDerivation {
  pname = "haskell-starter-webservice";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-casing base http-client-tls servant servant-client
    servant-server text
  ];
  executableHaskellDepends = [
    base lens servant-docs servant-server servant-swagger
    servant-swagger-ui swagger2 warp
  ];
  doHaddock = false;
  description = "A simple webservice";
  license = stdenv.lib.licenses.mit;
}
