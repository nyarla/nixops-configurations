{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configurations.nix
  ];

  networking.firewall = {
    enable          = true;
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

  environment.systemPackages = with pkgs; [
    coreutils curl
  ];

  environment.extraInit = ''
    if test ! -e /root/.ssh/authorized_keys ; then
      test -e /root/.ssh || mkdir -p /root/.ssh/
      cd /root/.ssh
      curl -L https://github.com/nyarla.keys -o authorized_keys
      chmod 600 authorized_keys
      cd /root
      chmod 700 .ssh
    fi
  '';
}
