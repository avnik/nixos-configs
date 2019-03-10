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
    gimp-with-plugins
    libreoffice
    maim sxiv
    pavucontrol
    qastools
    aumix
    mpv mplayer mpg123
    dex desktop_file_utils
    xsel
    ## windowmanagers, which I want to be built by default
    fvwm awesome qtile
    zathura ## for pdfs
    #apvlv ## for pdfs
  ];

  # I use systemwide pulse on my desktops, so won't have him go away on upgrades
  systemd.services.pulseaudio.restartIfChanged = false;
}
