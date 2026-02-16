{ lib, pkgs, config, inputs, ... }:
{
  imports = [
    ../users.nix
    ../users/default.nix
  ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    verbose = true;
    extraSpecialArgs = {
      inherit inputs;
    };
  };
}
