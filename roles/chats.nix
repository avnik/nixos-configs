{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
         (self: super:  {
             weechat = super.weechat.override { configure = {availablePlugins, ...}: {
                    scripts = with pkgs.weechatScripts; [
                        weechat-autosort
                        weechat-xmpp
                        weechat-matrix-bridge
                        wee-slack
                    ];
                };
             };
         })];
  environment.systemPackages = with pkgs; [
    irssi
    weechat
    tdesktop
  ];
}
