{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Unused for years
    #    discord
    # Unused for years
    #    irssi
    telegram-desktop
    # Unused for years
    #    skypeforlinux
    zoom-us
    ## Matrix
    # fractal-next

    gurk
    # signal-desktop
    # element-desktop
  ];
}
