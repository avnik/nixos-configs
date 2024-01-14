{ lib, pkgs, config, inputs, system, ... }:
{
    programs.doom-emacs = rec {
      enable = true;
      emacsPackage = pkgs.emacs29-pgtk; 
#      emacsPackagesOverlay = self: super: { 
#        vterm = super.vterm.overrideAttrs (oldAttrs: {
#          cmakeFlags = [
#            "-DEMACS_SOURCE=${emacsPackage.src}"
#            "-DUSE_SYSTEM_LIBVTERM=ON"
#          ];
#        });
#      }; 
      extraPackages = with pkgs; [ gcc ripgrep git pandoc ];
      doomPrivateDir = ./doom.d;
    };
}
