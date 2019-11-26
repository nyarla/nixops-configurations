{ stdenv, writeText, PORT, HOSTNAME }:
stdenv.mkDerivation rec {
  name    = "fathom-config";
  version = "2019-11-26";
  src     = "${writeText "fathom.args" ''
    --config=/app/fathom/env server --addr=127.0.0.1:${PORT} --hostname=${HOSTNAME} 
  ''}";

  phases = [ "installPhase" ];
  
  installPhase = ''
    mkdir -p $out/share/fathom
    cp ${src} $out/share/fathom/fathom.args
  '';
}
