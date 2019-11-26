{ config, pkgs, ... }:
{
  systemd.services.fathom = {
    enable      = true;
    description = "Fathom access analysis server";
    wantedBy    = [ "network.target" "multi-user.target" ];
    after       = [ "network.target" ];
    serviceConfig = {
      Type      = "simple";
      ExecStart = "${pkgs.stdenv.shell} -c '${pkgs.fathom}/bin/fathom $(cat ${pkgs.fathom-config}/share/fathom/fathom.args)'"; 
      User      = "www-data";
      Group     = "www-data";
    };
  }; 
}
