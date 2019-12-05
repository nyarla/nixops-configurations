self: super: let
  require = path: args: super.callPackage (import path) args ;
in {
  fathom = require ./pkgs/fathom/default.nix { };
  netlify-cms-oauth-provider = require ./pkgs/netlify-cms-oauth-provider/default.nix { };
}
