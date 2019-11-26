{ config, pkgs, ... }:
{
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.extraConfig = "serial --unit=0 --speed=115200 ; terminal_input serial console ; terminal_output serial console";

  boot.kernelParams = [
    "console=tty0"
    "console=ttyS0,115200n8"
  ]; 

  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs  = false;
  
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "jp106";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Asia/Tokyo";
}
