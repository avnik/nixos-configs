{ lib, pkgs, config, inputs, ... }:
#let
#  home-manager = builtins.fetchGit {
#    url = "https://github.com/nix-community/home-manager.git";
#    rev = "cc60c22c69e6967b732d02f072a9f1e30454e4f6"; # CHANGEME 
#  };
#in
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
