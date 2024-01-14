{ lib, pkgs, config, inputs, ... }:
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = false;
    nix-direnv.enable = true;
  };
}
