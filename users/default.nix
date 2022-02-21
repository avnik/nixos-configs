{ lib, pkgs, config, inputs, ... }:

{
  nixpkgs.overlays = [
        (self: super: {
           nix-direnv = super.nix-direnv.overrideAttrs (_: { 
              src = inputs.nix-direnv;
           });   
        })
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
}
