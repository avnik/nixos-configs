{ lib, pkgs, config, inputs, ... }:
{ ... }:

{
  imports = [
    inputs.nix-doom-emacs.hmModule
    ../common/xkb.nix
    ../common/x11.nix
    ../avn/direnv.nix
    #      ../avn/emacs.nix
  ];
  programs.zsh.initContent = ''
    bindkey '^R' history-incremental-search-backward
    bindkey -M viins '\e.' insert-last-word
  '';
  home.stateVersion = "22.05";
}
