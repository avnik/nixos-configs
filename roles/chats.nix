{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Unused for years
    #    discord
    # Unused for years
    #    irssi
    tdesktop
    # Unused for years
    #    skypeforlinux
    zoom-us
    ## Matrix
    # fractal-next
    nheko
    gomuks

    signal-desktop gurk
    element-desktop
  ];
}
