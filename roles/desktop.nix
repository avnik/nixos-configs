{ config, pkgs, ... }:

{
  nixpkgs.config.firefox = {
    enableAdobeFlash = true;
  };

  hardware = {
      opengl = {
          driSupport32Bit = true;
      };
  };

  services.openssh.forwardX11 = true;

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
    mpv mplayer mpg123 youtube-dl
    mp3splt mp3splt-gtk
    dex desktop_file_utils
    xsel
    ## windowmanagers, which I want to be built by default
    fvwm awesome qtile
    zathura ## for pdfs
    #apvlv ## for pdfs
  ];
}
