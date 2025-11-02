{ config, pkgs, inputs, system, ... }:
{
  programs = {
    nh = {
      enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    cachix
    deadnix
    nurl
    nix-diff
    #    nix-melt
    nix-tree
    nix-prefetch-scripts
    nix-prefetch
    nixpkgs-fmt
    nixfmt-rfc-style
    nixpkgs-review
    inputs.poetry2nix.packages.${system}.poetry2nix
    inputs.nix-fast-build.packages.${system}.nix-fast-build
    inputs.nix-update.packages.${system}.nix-update
    #    inputs.fast-flake-update.packages.${system}.fast-flake-update
  ];
}
