{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.steam.enable = true;
  programs.steam.extraPackages = [
    pkgs.libSM
    pkgs.libpng12
  ];
}
