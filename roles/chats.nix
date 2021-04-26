{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    irssi
    tdesktop
    skype
  ];
}
