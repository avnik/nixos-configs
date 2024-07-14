{ lib, pkgs, config, nixosConfig, ... }:
let
  toFootColor = c: lib.removePrefix "0x" c;
  toFootColors = section: cs: {
    "${section}0" = toFootColor cs.black;
    "${section}1" = toFootColor cs.red;
    "${section}2" = toFootColor cs.green;
    "${section}3" = toFootColor cs.yellow;
    "${section}4" = toFootColor cs.blue;
    "${section}5" = toFootColor cs.magenta;
    "${section}6" = toFootColor cs.cyan;
    "${section}7" = toFootColor cs.white;
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
