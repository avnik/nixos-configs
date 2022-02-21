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
      
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };
}

