self: super: let
  require = path: args: super.callPackage (import path) args ;
in {
  fathom = require ./pkgs/fathom/default.nix { };
}
