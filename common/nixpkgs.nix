{ config, pkgs, ... }:
{
  nixpkgs.config = {
     allowUnfree = true;
     pulseaudio = true;
     checkMeta = false;
     avahi.qt4Support = false;
     mpv = {
         cacaSupport = false;
         SDL2Support = true; # FIXME: require fix in nixpkgs/toplevel/all-packages
     };
     packageOverrides = pkgs: rec {
        inherit (import ./../pkgs { inherit pkgs; }) own;
        texLive = pkgs.texLive.override {
            preferLocalBuild = true;
        };
        pidgin-with-plugins =  pkgs.pidgin-with-plugins.override {
            plugins = [ pkgs.purple-plugin-pack pkgs.toxprpl pkgs.pidginotr pkgs.pidgin-skypeweb pkgs.pidginwindowmerge ];
        };
        deadbeef-with-plugins = pkgs.deadbeef-with-plugins.override {
            plugins = [ pkgs.deadbeef-mpris2-plugin ];
        };
     };
  };
}
