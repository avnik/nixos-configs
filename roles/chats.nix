{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    discord
    irssi
    tdesktop
    skype
    zoom-us
  ];
}
