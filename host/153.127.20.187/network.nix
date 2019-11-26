{ config, pkgs, ... }:
{
  networking.useDHCP = false;

  networking.firewall.interfaces.ens3.allowedTCPPorts = [ 80 443 ];
  networking.firewall.interfaces.ens3.allowedUDPPorts = [ 80 443 ];

  networking.interfaces.ens3 = {
    ipv4 = {
      addresses = [ { address = "153.127.20.187"; prefixLength = 23; } ];
    };
    ipv6 = {
      addresses = [ { address = "2401:2500:204:1108:153:127:20:187"; prefixLength = 64; } ];
    };
  };

  networking.defaultGateway = {
    address   = "153.127.20.1";
    interface = "ens3";
  };

  networking.defaultGateway6 = {
    address   = "fe80::1";
    interface = "ens3";
  };

  networking.nameservers = [ "133.242.0.3" "133.242.0.4" "2401:2500::1" ];
}
