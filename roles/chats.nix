{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    discord
    irssi
    tdesktop
    skypeforlinux
    zoom-us
    tensor nheko gomuks quaternion ## Matrix
    signal-desktop signal-cli gurk
  ];

  services.signald.enable = true;
}
