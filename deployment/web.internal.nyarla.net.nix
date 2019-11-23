{
  network.description = "server definition for web.internal.nyarla.net";
  server = { config, pkgs, ... }: {
    deployment.targetHost = "153.127.20.187";
    deployment.targetPort = 57092;
    imports = [
      ../host/153.127.20.187/hardware-configuration.nix
      ../host/153.127.20.187/network.nix
      ../profile/web.nix
    ];
  };
}
