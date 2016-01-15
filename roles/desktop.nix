{ config, pkgs, ... }:
{
    nixpkgs.config.firefox = {
      enableAdobeFlash = true;
    };

    environment.systemPackages = with pkgs; [
      chromium
      pkgs.firefoxWrapper
      skype
      gimp
      pavucontrol
      qastools
      aumix
      mpv mplayer mpg123
      zathura
    ];
}
