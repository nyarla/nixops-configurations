{ stdenv }:
stdenv.mkDerivation rec {
  name    = "netlify-cms-oauth-provider";
  version = "git";
  src     = ./netlify-cms-oauth-provider;
  phases  = [ "installPhase" ];
  
  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/netlify-cms-oauth-provider
    chmod +x $out/bin/netlify-cms-oauth-provider
  '';
}
