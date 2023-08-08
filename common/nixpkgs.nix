{ config, pkgs, lib, ... }:
{
  imports = [
    ../pkgs/default.nix # Custom packages
  ];
  nixpkgs.config = {
     allowUnfree = true;
     allowBroken = true;
     pulseaudio = true;
#     checkMeta = false;
     showDerivationWarnings =  [ ];
     packageOverrides = pkgs: rec {
        texLive = pkgs.texLive.override {
            preferLocalBuild = true;
        };
     };
#     allowInsecurePredicate = pkg: (pkg.pname == "qtwebkit" || pkg.name == "python-2.7.18.6");
     permittedInsecurePackages = [
     ];
  };
}
