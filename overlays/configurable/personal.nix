self: super: let
  require = path: args: super.callPackage (import path) args ;
in {
  acme-update = require ./pkgs/acme-update/default.nix {
    HOME    = "/home/www-data";
    DESTDIR = "/data/certificates";
    domains = [
      "nyarla.net" "nyadgets.net" "kalaclista.com"
    ];
  };

  fathom-config = require ./pkgs/fathom-config/default.nix {
    PORT      = "10001";
    HOSTNAME  = "analysis.nyarla.net";
  };

  h2o-config = require ./pkgs/h2o-config/default.nix {
    buildScript = ./dotfiles/personal/h2o.yml.pl;
  };
}
