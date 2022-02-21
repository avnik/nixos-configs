{ lib, pkgs, config, inputs, ... }:
{...}:

{
    imports = [ 
     inputs.nix-doom-emacs.hmModule
      ../common/xkb.nix
      ./x11.nix
      ./direnv.nix
      ./emacs.nix
      ./sway.nix
      ./i3status.nix
      ];
    xdg.configFile."alacritty/alacritty.yml" = { source = ./alacritty.yml; };
}
