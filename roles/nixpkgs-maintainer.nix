{ config, pkgs, inputs, system, ... }:
{
  environment.systemPackages = with pkgs; [
    cachix
    deadnix
    nurl
    nix-diff
    nix-prefetch-scripts
    nix-update-source
    nix-prefetch-scripts
    nix-prefetch
    nixpkgs-fmt
    nixpkgs-review
    inputs.poetry2nix.packages.${system}.poetry2nix
    inputs.nix-fast-build.packages.${system}.nix-fast-build
    inputs.fast-flake-update.packages.${system}.fast-flake-update
  ];
}
