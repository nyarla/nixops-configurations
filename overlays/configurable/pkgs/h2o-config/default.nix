{ stdenv, perl, perlPackages, buildScript }:
stdenv.mkDerivation rec {
  name    = "h2o-config";
  version = "2019-11-26";
  phases  = [ "installPhase" ];
  src     = buildScript;

  nativeBuildInputs = [
    perl perlPackages.YAMLTiny
  ];

  installPhase = ''
    mkdir -p $out/share/h2o
    perl ${src} >$out/share/h2o/h2o.yml
  '';
}
