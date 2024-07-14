{ mod, terminal, pkgs, lib, sway ? false }:
let
  i3specific = if sway then { } else {
    "${mod}+Shift+r" = "restart";
    "${mod}+Shift+q" = "restart";
  };
  swaySpecific =
    if sway then {
      "${mod}+p" = "exec tessen -p gopass -d fuzzel";
    } else { };
in
{
  "${mod}+1" = "workspace 1";
  "${mod}+2" = "workspace 2";
  "${mod}+3" = "workspace 3";
  "${mod}+4" = "workspace 4";
  "${mod}+5" = "workspace 5";
  "${mod}+6" = "workspace 6";
  "${mod}+7" = "workspace 7";
  "${mod}+8" = "workspace 8";
  "${mod}+9" = "workspace 9";
  "${mod}+0" = "workspace 10";
  "${mod}+w" = "workspace \"Web\"";
  "${mod}+i" = "workspace \"Irc\"";
  "${mod}+Shift+1" = "move container to workspace 1";
  "${mod}+Shift+2" = "move container to workspace 2";
  "${mod}+Shift+3" = "move container to workspace 3";
  "${mod}+Shift+4" = "move container to workspace 4";
  "${mod}+Shift+5" = "move container to workspace 5";
  "${mod}+Shift+6" = "move container to workspace 6";
  "${mod}+Shift+7" = "move container to workspace 7";
  "${mod}+Shift+8" = "move container to workspace 8";
  "${mod}+Shift+9" = "move container to workspace 9";
  "${mod}+Shift+0" = "move container to workspace 10";
  "${mod}+Shift+w" = "move container to workspace \"Web\"";
  "${mod}+Shift+i" = "move container to workspace \"Irc\"";

  "${mod}+Left" = "focus left";
  "${mod}+Down" = "focus down";
  "${mod}+Up" = "focus up";
  "${mod}+Right" = "focus right";
  "${mod}+Tab" = "focus up";
  "${mod}+Shift+Tab" = "focus down";

  "${mod}+Shift+Left" = "move left";
  "${mod}+Shift+Down" = "move down";
  "${mod}+Shift+Up" = "move up";
  "${mod}+Shift+Right" = "move right";

  "${mod}+Shift+h" = "layout splith";
  "${mod}+Shift+v" = "layout splitv";
  "${mod}+Shift+s" = "layout stacking";
  "${mod}+Shift+t" = "layout tabbed";
  "${mod}+Shift+f" = "floating toggle";
  "${mod}+space" = "focus mode_toggle";

  "${mod}+h" = "split h";
  "${mod}+v" = "split v";
  "${mod}+f" = "fullscreen";
  "${mod}+c" = "kill";

  "${mod}+Return" = "exec ${terminal}";
} // i3specific // swaySpecific
