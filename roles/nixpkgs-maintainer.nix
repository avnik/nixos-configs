{ config, pkgs, inputs, system, ... }:
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
    inputs.poetry2nix.packages.${system}.poetry2nix
    inputs.nix-fast-build.packages.${system}.nix-fast-build
    inputs.fast-flake-update.packages.${system}.fast-flake-update
  ];
}
