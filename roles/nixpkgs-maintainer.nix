{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cachix
    deadnix
    niv
    nix-diff
    nix-prefetch-scripts
    nix-top
    nix-update-source
    nix-universal-prefetch
    nix-prefetch-scripts
    nix-prefetch
    nixpkgs-fmt
    nixpkgs-review
    poetry2nix.cli
  ];
}
