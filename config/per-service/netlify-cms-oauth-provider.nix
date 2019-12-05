{ config, pkgs, ... }:
{
  systemd.services.netlify-cms-oauth-provider = {
    enable      = true;
    description = "Fathom access analysis server";
    wantedBy    = [ "network.target" "multi-user.target" ];
    after       = [ "network.target" ];
    serviceConfig = {
      Type      = "simple";
      ExecStart = "${pkgs.stdenv.shell} -c 'cd /app/netlify-cms-oauth-provider && ${pkgs.netlify-cms-oauth-provider}/bin/netlify-cms-oauth-provider'"; 
      User      = "www-data";
      Group     = "www-data";
    };
  }; 
}
