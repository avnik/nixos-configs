{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dosbox
    lgogdownloader
    minetest
    opendungeons
    openxcom
    rocksndiamonds
    scummvm
    stellarium
    wesnoth
  ];
}
