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
  };

  services.xserver.displayManager.lightdm.enable = true;

  environment.systemPackages = with pkgs; [
    rxvt-unicode
    xorg.xkbcomp
    xorg.xlsatoms
    xorg.xkill
    xorg.xdpyinfo
    xorg.xdriinfo
    glxinfo
    xorg.xev
    xorg.xgamma
    xorg.xmodmap
    xorg.xwininfo
    autocutsel
    # FIXME: should opencl-info be in common, X11 or desktop?
    #    opencl-info 
    xorg.xkbcomp
    wmctrl
    xdotool
  ];

}
