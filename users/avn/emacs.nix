{ lib, pkgs, config, inputs, system, ... }:
{
    programs.doom-emacs = {
      enable = true;
      # emacsPackage = pkgs.emacsPgtkNative; 
      emacsPackagesOverlay = self: super: { 
      }; 
      extraPackages = with pkgs; [ ripgrep git pandoc ];
      doomPrivateDir = ./doom.d;
    };
}
