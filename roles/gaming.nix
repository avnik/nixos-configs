{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dosbox
    lgogdownloader
    openxcom
    wesnoth
    minetest
  ];
}
