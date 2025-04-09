{ config, pkgs, inputs, ... }:


{
  hardware = {
    graphics = {
      enable32Bit = true;
    };
  };

  services.openssh.settings.X11Forwarding = true;
  home-manager.sharedModules = [
    {
      programs.chromium = {
        enable = true;
        package = pkgs.chromium;
      };
      home.packages = [ pkgs.libreoffice ];
    }
  ];

  services.speechd.enable = false;

  environment.systemPackages = with pkgs; [
    anki
    aichat
    alock
    brewtarget
    firefox
    gimp-with-plugins
    # gimp
    blender
    #krita
    rawtherapee
    minder
    pavucontrol
    pwvucontrol helvum qpwgraph
    qastools
    mpv
    mpg123
    yt-dlp # Was: youtube-dl
    mp3splt
    mp3splt-gtk
    desktop-file-utils
    zathura ## for pdfs
    krop ## for pdfs
  ];
}
