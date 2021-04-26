{ libs, pkgs, config, ... }:
let
  mod = "Mod4"; 
  i3 = pkgs.i3-gaps;
  configFile = ./i3config;
  # Validates the i3 configuration
  checkI3Config =
    pkgs.runCommandLocal "i3-config" { buildInputs = [ i3 ]; } ''
      # We have to make sure the wrapper does not start a dbus session
      export DBUS_SESSION_BUS_ADDRESS=1

      # A zero exit code means i3 succesfully validated the configuration
      i3 -c ${configFile} -C -d all || {
        echo "i3 configuration validation failed"
        echo "For a verbose log of the failure, run 'i3 -c ${configFile} -C -d all'"
        exit 1
      };
      cp ${configFile} $out
    '';
in
{
  home.packages = [ i3 ];
  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        settings = {
                theme =  {
                  name = "solarized-dark";
                  overrides = {
                    idle_bg = "#123456";
                    idle_fg = "#abcdef";
                  };
                };
              };
        blocks = [
         { block ="focused_window"; max_width=200; }
         { block="load"; format="{1m} {5m} {15m}"; interval=1; }
         {block="memory"; }
         { block="time"; format="⏰ %F %a %T"; interval=1; locale="en_US"; }
        ];
      };
    };
  };
  xdg = {
    enable = true;
    configFile."i3/config" = {
        source = checkI3Config;
        onChange = ''
          i3Socket=''${XDG_RUNTIME_DIR:-/run/user/$UID}/i3/ipc-socket.*
          if [ -S $i3Socket ]; then
            echo "Reloading i3"
            $DRY_RUN_CMD ${i3}/bin/i3-msg -s $i3Socket reload 1>/dev/null
          fi
        '';
    };
  }; 
  xsession = {
    enable = true;
    scriptPath = ".xsession";
    initExtra = ''
      xset m 5 2 c 0 b 0

      #XRDB
      if [ -d "$HOME/.Xresources.d" ] && type xrdb >/dev/null 2>&1; then
        RESOURCEFILES=$(find $HOME/.Xresources.d -type f -o -type l)
        if [ -n "$RESOURCEFILES" ]; then
          for RESOURCEFILE in $RESOURCEFILES; do
              xrdb -merge $RESOURCEFILE
          done
        fi
      fi

      # Screensaver -> off
      xset -dpms
      xset s off
      xset s noblank 
      xrandr --output DisplayPort-0 --gamma 1.6:1.6:1.6 
      # XKB
      xkbcomp -I$HOME/.xkb $HOME/.xkb/main.xkb $DISPLAY >/dev/null 2>&1
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    windowManager.command = "i3";
    windowManager.i3 = {
      enable = false;
      config = rec {
        modifier = "Mod4";
        keybindings = import ./keybindings.nix { mod = modifier; };
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
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs /home/avn/.config/i3status-rust/config-default.toml";
          fonts = [ "monospace 10"];
#          height = 30;
        }];
      };
      extraConfig = ''
        for_window [class="^.*"] border pixel 2
      '';
    };
  };
}

