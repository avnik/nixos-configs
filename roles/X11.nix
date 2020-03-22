{ config, pkgs, ... }:

{

  imports = [
    ../common/fonts.nix
  ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    videoDrivers = [ "ati" ];
    exportConfiguration = true;
  # Glamor still buggy on my Radeon HD6670
  # useGlamor = true;

  };

  services.xserver.displayManager.lightdm.enable = true;

  environment.systemPackages = with pkgs; [
    fvwm qtile
    rxvt_unicode
    xlibs.xkbcomp
    xorg.xlsatoms xorg.xkill
    xorg.xdpyinfo xorg.xdriinfo glxinfo xorg.xev xorg.xgamma xorg.xmodmap xorg.xwininfo autocutsel
# FIXME: should opencl-info be in common, X11 or desktop?
    opencl-info 
    xlibs.xkbcomp
    wmctrl xdotool
  ];

}
