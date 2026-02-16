{ config, pkgs, ... }:

{

  imports = [
    ../common/fonts.nix
  ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    videoDrivers = [ "ati" ];
    exportConfiguration = true;
  };

  services.xserver.displayManager.lightdm.enable = true;

  environment.systemPackages = with pkgs; [
    rxvt-unicode
    xkbcomp
    xlsatoms
    xkill
    xdpyinfo
    xdriinfo
    xev
    xgamma
    xmodmap
    xwininfo
    autocutsel
    # FIXME: should opencl-info be in common, X11 or desktop?
    #    opencl-info
    wmctrl
    xdotool
    xsel
  ];

}
