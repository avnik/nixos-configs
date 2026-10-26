{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [ ./neovim/base.nix ];
    }).neovim
  ];
}
