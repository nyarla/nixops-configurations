{ config, pkgs, ... }:
{
  nixpkgs.overlays = [
    (import ../../overlays/app/default.nix)
    (import ../../overlays/modified/default.nix)
    (import ../../overlays/configurable/personal.nix)
  ];
}
