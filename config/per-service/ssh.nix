{ config, pkgs, ... }:
{
  networking.firewall = {
    allowedTCPPorts = [ 57092 ];
  };

  services.openssh = {
    enable          = true;
    ports           = [ 57092 ];
    listenAddresses = [
      { addr = "0.0.0.0"; port = 57092; }
    ];

    challengeResponseAuthentication = false;
    passwordAuthentication = false;
    permitRootLogin = "prohibit-password";
  };
}
