{ config, pkgs, ... }:

let dwarf = pkgs.dwarf-fortress.override {
      enableDFHack = true;
      enableStoneSense = true;
      enableSoundSense = true;
      theme = "phoebus";
}; in

{
  environment.systemPackages = with pkgs; [
#    dwarf-therapist
#    dwarf
    dosbox
    kerbal
    lgogdownloader
    minetest
    opendungeons
    openxcom
    rocksndiamonds
    scummvm
    stellarium
    wesnoth
  ];
}
