{ config, pkgs, ... }:
{
  imports = [
    ../config/per-account/www-data.nix
    
    ../config/per-service/firewall.nix
    ../config/per-service/ssh.nix
  ];
}
