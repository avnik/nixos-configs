{ lib, pkgs, config, inputs, ... }:
{...}:

{
    imports = [ 
      inputs.nix-doom-emacs.hmModule
      ../common/xkb.nix
      ../common/x11.nix
      ../avn/direnv.nix
      ../avn/emacs.nix
      ];
}
