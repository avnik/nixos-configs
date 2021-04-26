{ config, pkgs, ... }:

{
  hardware = {
      opengl = {
          driSupport32Bit = true;
      };
  };

  services.openssh.forwardX11 = true;

  environment.systemPackages = with pkgs; [
    alock
    alacritty
    chromium
    firefox
    gimp-with-plugins rawtherapee # photoflow
    libreoffice
    maim sxiv
    pavucontrol
    qastools
    aumix
    mpv mpg123 youtube-dl
    mp3splt mp3splt-gtk
    dex desktop_file_utils
    xsel
    ## windowmanagers, which I want to be built by default
    fvwm qtile
    zathura ## for pdfs
  ];
}
