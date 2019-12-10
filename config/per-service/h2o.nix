{ config, pkgs, ... }:
{
  systemd.services.acme-update = {
    enable      = true;
    description = "Automatic Certificate updates for Let's Encrypt.";
    unitConfig  = {
      RefuseManualStart = "no";
      RefuseManualStop  = "yes";
    }; 
    serviceConfig = {
      Type      = "oneshot";
      ExecStart = "${pkgs.writeScript "acme-update-wrapper.sh" ''
        #!${pkgs.stdenv.shell}
        su - www-data <"$(cat ${pkgs.acme-update}/bin/acme-update)"
        ${pkgs.coreutils}/bin/kill -HUP $(cat /app/h2o/h2o.pid)
      ''}";
    };
  };

  systemd.timers.acme-update = {
    enable      = true;
    description = "Trigger acme-update script at every sunday 03:00";
    wantedBy    = [ "timer.target" "network.target" "mult-user.target" ];
    timerConfig  = {
      OnCalendar = "*-*-7,21 03:00:00";
      Persistent = "true";
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 80 443 ];

  systemd.services.h2o = {
    enable      = true;
    description = "h2o http/2 server";
    wantedBy    = [ "network.target" "multi-user.target" ];
    after       = [ "network.target" ];
    serviceConfig = {
      Type          = "forking";
      PIDFile       = "/app/h2o/h2o.pid";
      ExecStartPre  = "/run/wrappers/bin/sudo -u www-data ${pkgs.stdenv.shell} ${pkgs.writeScript "prepare-h2o" ''
        if test ! -d /data/certificates ; then
          ${pkgs.acme-update}/bin/acme-update
        fi

        test -d /data/log/error || mkdir -p /data/log/error
        test -d /data/log/http  || mkdir -p /data/log/http
        test -d /data/log/https || mkdir -p /data/log/https
        test -d /app/h2o/       || mkdir -p /app/h2o 
      ''}";
      ExecStart     = "${pkgs.h2o}/bin/h2o -m daemon -c ${pkgs.h2o-config}/share/h2o/h2o.yml";
      ExecReload    = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
    };
    path        = with pkgs; [
      h2o openssl perl
    ];
  };

  services.logrotate = {
    enable = false;
    config = ''
      /data/log/*/*.log {
        ifempty
        dateformat .%Y-%m-%d
        missingok
        compress
        daily
        rotate 14
        postrotate
          /run/current-system/sw/bin/systemctl reload h2o
        endscript
      }
    '';
  };
}
