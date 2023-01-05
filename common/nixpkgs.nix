{ config, pkgs, lib, ... }:
{
  imports = [
    ../pkgs/default.nix # Custom packages
  ];
  nixpkgs.config = {
     allowUnfree = true;
     allowBroken = true;
     pulseaudio = true;
     checkMeta = false;
     mpv = {
         cacaSupport = false;
         SDL2Support = true; # FIXME: require fix in nixpkgs/toplevel/all-packages
     };
     packageOverrides = pkgs: rec {
        texLive = pkgs.texLive.override {
            preferLocalBuild = true;
        };
     };
     allowInsecurePredicate = pkg: pkg.pname == "qtwebkit";
  };
}
