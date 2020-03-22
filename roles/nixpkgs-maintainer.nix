{ config, pkgs, ... }:
{
  services.lorri.enable = true;
  environment.systemPackages = with pkgs; [
    niv
#    nix-deploy
#    nix-delegate
    nix-diff
    nix-prefetch-scripts
    nix-update-source
    nix-universal-prefetch
    nix-prefetch-scripts
    nixpkgs-fmt
    nixpkgs-review
  ];
}
