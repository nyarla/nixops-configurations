self: super: {
  acme-sh = super.callPackages "${super.fetchurl {
    url     = "https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/tools/admin/acme.sh/default.nix";
    sha256  = "1rhs3i704mfc48g40yls3y5b2gi7a3q5x549ga25h3szw8sksq4l";
  }}" { };
}
