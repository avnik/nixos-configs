{ lib, pkgs, config, inputs, ... }:

{
  nixpkgs.overlays = [
  ];
  environment.systemPackages = [
    pkgs.qt5.qtwayland
  ];
  home-manager.users.avn = import ./avn/home.nix {
    inherit lib pkgs config inputs;
  };
  home-manager.users.olga = import ./olga/home.nix {
    inherit lib pkgs config inputs;
  };
  home-manager.users.kris = import ./olga/home.nix {
    inherit lib pkgs config inputs;
  };
}
