{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name    = "fathom";
  version = "v1.2.1";
  src     = fetchurl {
    url     = "https://github.com/usefathom/fathom/releases/download/v1.2.1/fathom_1.2.1_linux_amd64.tar.gz";
    sha256  = "0sfpxh2xrvz992k0ynib57zzpcr0ikga60552i14m13wppw836nh";
  };

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    tar -zxvf ${src} -C .
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp fathom $out/bin/fathom
    chmod +x $out/bin/fathom
  '';
}
