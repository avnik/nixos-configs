{ pkgs, lib, ... }:

{
   xdg.portal = {
     enable = true;
     wlr = {
        enable = true;
        settings = {
          screencast = {
            output_name = "DP-1";
            max_fps = 30;
            # exec_before = "disable_notifications.sh";
            # exec_after = "enable_notifications.sh";
            chooser_type = "simple";
            chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
          };
        };
     };
     extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
   };
   xdg.autostart.enable = lib.mkOverride 1400 false;
}
