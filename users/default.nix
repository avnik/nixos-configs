{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:

let
  mkHome =
    path:
    import path {
      inherit
        lib
        pkgs
        config
        inputs
        ;
      nixosConfig = config;
    };
in

{
  environment.systemPackages = [
    pkgs.qt5.qtwayland
  ];

  # Keep this curried style for now: each users/*/home.nix is a two-arg module
  # ({...}: { ... }:) and Home Manager applies the module args itself.
  # TODO: reduce boilerplate by converting user homes to a single HM module
  # function and pass only truly custom args once via home-manager.extraSpecialArgs.
  home-manager.users.avn = mkHome ./avn/home.nix;
  home-manager.users.olga = mkHome ./olga/home.nix;
  home-manager.users.kris = mkHome ./kris/home.nix;
}
