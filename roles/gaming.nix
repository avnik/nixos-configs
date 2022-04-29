{ config, pkgs, ... }:

let dwarf = pkgs.dwarf-fortress.override {
      enableDFHack = true;
      enableStoneSense = true;
      enableSoundSense = true;
      theme = "phoebus";
}; in

let minetestclient_5_custom = pkgs.runCommand "minetest-5" {} ''
    mkdir -p $out/bin
    ln -s ${pkgs.minetestclient_5}/bin/minetest $out/bin/minetest-5
''; in

{
  environment.systemPackages = with pkgs; [
#    dwarf-therapist
#    dwarf
    dosbox
    kerbal
#    lgogdownloader
#    minetestclient_4
#    minetestclient_5_custom
    openxcom-extended
#    rocksndiamonds
    runelite
    scummvm
    stellarium
    wesnoth
    xmage
  ];
}
