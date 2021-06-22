{ lib, pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    foot
    kitty
  ];
}
