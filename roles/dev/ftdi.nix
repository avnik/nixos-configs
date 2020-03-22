{ config, pkgs, ... }:

{
  services.udev.extraRules = ''
    SUBSYSTEM=="tty" ATTRS{idVendor}=="0403" ATTRS{idProduct}=="6001" ATTRS{serial}=="FT9UAUHT" SYMLINK+="ttyUART-macnica-left" MODE="0666"
    SUBSYSTEM=="tty" ATTRS{idVendor}=="0403" ATTRS{idProduct}=="6001" ATTRS{serial}=="FT9ZONCN" SYMLINK+="ttyUART-macnica-right" MODE="0666"
  '';
}
