{ lib, pkgs, config, inputs, system, ... }:
{
  programs.doom-emacs = rec {
    enable = true;
    emacs = pkgs.emacs30-pgtk;
    extraPackages = epkgs: [ epkgs.vterm ];
    #      emacsPackagesOverlay = self: super: { 
    #        vterm = super.vterm.overrideAttrs (oldAttrs: {
    #          cmakeFlags = [
    #            "-DEMACS_SOURCE=${emacsPackage.src}"
    #            "-DUSE_SYSTEM_LIBVTERM=ON"
    #          ];
    #        });
    #      }; 
    extraBinPackages = with pkgs; [ ripgrep git pandoc ];
    doomDir = ./doom.d;
  };
}
