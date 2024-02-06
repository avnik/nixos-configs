{ config, pkgs, inputs, ... }:


{
  hardware = {
    opengl = {
      driSupport32Bit = true;
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

  environment.systemPackages = with pkgs; [
    anki
    alock
    brewtarget
    firefox
    homebank
    gimp-with-plugins
    blender
    krita
    rawtherapee
    maim
    sxiv
    minder
    pavucontrol
    qastools
    aumix
    mpv
    mpg123
    youtube-dl
    vlc
    mp3splt
    mp3splt-gtk
    desktop-file-utils
    xsel
    zathura ## for pdfs
    sweethome3d.application
    sweethome3d.furniture-editor
#    krop    # 18.01.2024, doesn't build
  ];
}
