{ config, pkgs, ... }:
{
  nixpkgs.config.firefox = {
    enableAdobeFlash = true;
  };

  hardware = {
      opengl = {
          driSupport32Bit = true;
          s3tcSupport = true;
      };

      pulseaudio = {
          enable = true;
          systemWide = true;
      };
  };

  environment.systemPackages = with pkgs; [
    alock
    chromium
    firefox
    skype
    gimp-with-plugins
    libreoffice
    maim sxiv
    pavucontrol
    qastools
    aumix
    mpv mplayer mpg123
    zathura
    irssi weechat
    dex desktop_file_utils
    xsel
    ## windowmanagers, which I want to be built by default
    fvwm awesome qtile
  ];

  systemd.services.pulseaudio.restartIfChanged = false;
}
