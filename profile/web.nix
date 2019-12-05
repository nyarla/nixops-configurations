{ config, pkgs, ... }:
{
  imports = [
    ../config/per-host/personal.nix

    ../config/per-account/www-data.nix
    
    ../config/per-service/firewall.nix
    ../config/per-service/ssh.nix

    ../config/per-service/h2o.nix
    ../config/per-service/fathom.nix
    ../config/per-service/netlify-cms-oauth-provider.nix
  ];
}
