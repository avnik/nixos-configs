{ lib, pkgs, config, nixosConfig, ... }:
let
  modifier = "Mod4";
  hostname = nixosConfig.networking.hostName;
  username = config.home.username;
  xkbcomp = pkgs.xorg.xkbcomp;
  xkb-sources = ./xkb;
  xkb-blob = host: pkgs.runCommand "xkb-blob" { } ''
    mkdir $out
    ${xkbcomp}/bin/xkbcomp -I${xkb-sources} -xkb -o $out/default.xkb ${xkb-sources}/models/${host}.xkb
  '';
  xkb = "${xkb-blob hostname}/default.xkb";
in
{
#  home.packages = [ pkgs.sway ];
  xdg.configFile."chromium-flags.conf".source = pkgs.writeText "chromum-flags.conf" ''
    --enable-features=UseOzonePlatform --ozone-platform=wayland
  '';
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
          font = "Droid Sans Mono:size=12";
          dpi-aware = "yes";
        };
       mouse = {
         hide-when-typing = "yes";
       };
    };
  };
  wayland.windowManager.sway = {
       enable = true;
       config = rec {
         inherit modifier;
         terminal = "footclient";
         bindkeysToCode = true;
         workspaceLayout = "stacking";
         defaultWorkspace = "1";
         input = {
           "*" = {
              xkb_file = "${xkb}";
           };
         };
         keybindings = import ./keybindings.nix { mod = modifier; terminal="footclient"; };
         assigns = {
           "web" = [{ class = "^Firefox$"; }];
           "2" = [{ class = "^Chromium$"; }];
         };
         gaps = {
           smartGaps = false;
           smartBorders = "no_gaps";
         };
         bars = [{
           mode = "dock";
           hiddenState = "show";
           position = "top";
           workspaceButtons = true;
           workspaceNumbers = true;
           statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs /home/${username}/.config/i3status-rust/config-default.toml";
           fonts = { names = [ "monospace"]; size=10.0; };
 #          height = 30;
         }];
       };
       extraConfig = ''
         bindsym ${modifier}+Tab focus next
         bindsym ${modifier}+Shift+Tab focus prev
         for_window [class="^.*"] border pixel 2
       '';
       extraSessionCommands = ''
         export SDL_VIDEODRIVER=wayland
         # needs qt5.qtwayland in systemPackages
         export QT_QPA_PLATFORM=wayland
         export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
         # Fix for some Java AWT applications (e.g. Android Studio),
         # use this if they aren't displayed properly:
         export _JAVA_AWT_WM_NONREPARENTING=1
         export MOZ_ENABLE_WAYLAND=1
         export GDK_BACKEND=wayland
         export CLUTTER_BACKEND=wayland
       '';
     };
}
