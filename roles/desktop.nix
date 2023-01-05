{ config, pkgs, inputs, ... }:


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
    brewtarget
    stable.chromium
    firefox
    gimp-with-plugins rawtherapee
    libreoffice
    maim sxiv
    pavucontrol
    qastools
    aumix
    mpv mpg123 youtube-dl vlc
    mp3splt mp3splt-gtk
    desktop-file-utils
    xsel
    zathura ## for pdfs
    sweethome3d.application
    sweethome3d.furniture-editor
  ];
}
