{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    ];

  boot.initrd.availableKernelModules = [  "ata_piix" "uhci_hcd" "ehci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f87fa53d-4cc8-4b72-bb7c-9be7f3b2b5b9";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/24eefe5e-5854-4387-9bfb-829f3f605c43"; }
    ];

  nix.maxJobs = lib.mkDefault 2;
}
