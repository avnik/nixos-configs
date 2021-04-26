{ lib, pkgs, config, ... }:

let
  doomEmacsNix = builtins.fetchGit {
    url = "https://github.com/vlaci/nix-doom-emacs.git";
    ref = "develop";
    rev = "51645030623075a50f0f2fb8e95d113336fa109f";
  };
  doomEmacs = pkgs.callPackage doomEmacsNix {
    doomPrivateDir = ./doom.d;
    dependencyOverrides = {
        "emacs-overlay" = builtins.fetchGit {
          url = "https://github.com/nix-community/emacs-overlay";
          ref = "master";
          rev = "d9530a7048f4b1c0f65825202a0ce1d111a1d39a";
         };
        "doom-emacs" = builtins.fetchGit {
           url = "https://github.com/hlissner/doom-emacs";
           ref = "develop";
           rev = "ce65645fb87ed1b24fb1a46a33f77cf1dcc1c0d5";
        };
      };
   emacsPackagesOverlay = self: super: { 
      sln-mode = pkgs.runCommand "sln-mode-stub" {} "";
    };
  };
in

{
  nixpkgs.overlays = [
        (self: super: {
           nix-direnv = super.nix-direnv.overrideAttrs (_: { 
              src = builtins.fetchGit {
                  url = "https://github.com/nix-community/nix-direnv.git";
                  rev = "300258e2bded28c284451f4fac8475b2240b46f6"; # CHANGEME 
                  narHash = "sha256-xMz6e0OLeB3eltGrLV3Hew0lMjH5LSgqJ1l7JT2Ho/M=";
              };
           });   
        })
  ];
  home-manager.users.avn = {...}: {
    imports = [ ./x11.nix ./sway.nix ];
    xdg.configFile."alacritty/alacritty.yml" = { source = ./alacritty.yml; };
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = false;
      enableNixDirenvIntegration = true;
    };
    programs.emacs = {
      package = doomEmacs;
      enable = true;
    };
    home.file.".emacs.d/init.el".text = ''
      (load "default.el")
    '';
  };
}
