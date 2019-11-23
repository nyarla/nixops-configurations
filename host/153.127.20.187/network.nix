{ config, pkgs, ... }:
{
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

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
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "jp106";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Asia/Tokyo";

}
