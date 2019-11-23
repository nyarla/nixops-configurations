{ config, pkgs, ... }:
{
  users.users.www-data = {
    createHome    = true;
    description   = "data access account for www services";
    group         = "www-data";
    isNormalUser  = true;
  };

  users.groups.www-data = {};
}
