{ config, inputs, pkgs, lib, ...}:
let
  wallpaper = inputs.nix-wallpaper.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    preset = "catppuccin-mocha-rainbow";
    width = 1920;
    height = 1200;
  };
in
{
  imports = [
    inputs.catppuccin-nix.nixosModules.catppuccin
    inputs.stylix.nixosModules.stylix
  ];

  catppuccin.flavor = "mocha";
  stylix = {
    enable = true;
    autoEnable = false;
    image = "${wallpaper}/share/wallpapers/nixos-wallpaper.png";
    base16Scheme = "${inputs.catppuccin-base16.outPath}/base16/${config.catppuccin.flavor}.yaml";
    fonts = {
      sansSerif = {
        name = "Droid Sans";
        package = pkgs.droid-fonts;
      };
      monospace = {
        name = "Droid Sans Mono";
        package = pkgs.droid-fonts;
      };
      sizes = {
        desktop = 11;
        popups = 13;
        terminal = 13; 
      };
    };
  };
}
