{ lib, pkgs, config, nixosConfig, ... }:
let
  toFootColor = c: lib.removePrefix "0x" c;
  toFootColors = section: cs: {
    "${section}0" = cs.black;
    "${section}1" = cs.red;
    "${section}2" = cs.green;
    "${section}3" = cs.yellow;
    "${section}4" = cs.blue;
    "${section}5" = cs.magenta;
    "${section}6" = cs.cyan;
    "${section}7" = cs.white;
  };
  colors = import ./colors.nix;
in
{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "Droid Sans Mono:size=13";
        dpi-aware = "yes";
        word-delimiters = ",│`|\"'()[]{}<>";
        notify = "${pkgs.libnotify}/bin/notify-send -a foot -i foot \${title} \${body}";
      };
      scrollback.lines = 32768;
      url.launch = "${pkgs.xdg-utils}/bin/xdg-open \${url}";
      mouse = {
        hide-when-typing = "yes";
      };
      tweak = {
        overflowing-glyphs = "true";
      };
      search-bindings = {
        find-prev = "Control+Up";
        find-next = "Control+Down";
      };
      colors = {
        foreground = toFootColor colors.primary.foreground;
        background = toFootColor colors.primary.background;
      } // toFootColors "regular" colors.normal
      // toFootColors "bright" colors.bright
      // toFootColors "dim" colors.dim;
    };
  };
}
