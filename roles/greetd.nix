{
  config,
  lib,
  pkgs,
  ...
}:
let
  swayPkg =
    if config.programs.sway.enable && config.programs.sway.package != null then
      config.programs.sway.package
    else
      pkgs.sway;
in
{
  environment.etc."greetd/environments".text = ''
    systemd-cat -t sway sway
    systemd-cat -t i3 startx ~/.xsession
  '';
  #    ${lib.optionalString config.programs.sway.enable "systemd-cat -t sway sway"}
  #    ${lib.optionalString config.services.xserver.windowManager.i3.enable "systemd-cat -t i3 startx ~/.xsession"}
  hardware.graphics.enable = lib.mkDefault true;
  services.xserver.displayManager.lightdm.enable = lib.mkForce false;
  services.greetd =
    let
      #      theme = "${pkgs.ayu-theme-gtk}/share/themes/Ayu-Dark/gtk-3.0/gtk.css";
      greetdSwayCfg = pkgs.writeText "sway-config" ''
        exec "${pkgs.gtkgreet}/bin/gtkgreet -l; ${swayPkg}/bin/swaymsg exit"
        bindsym Mod4+shift+e exec ${swayPkg}/bin/swaynag \
        -t warning \
        -m 'What do you want to do?' \
        -b 'Poweroff' 'systemctl poweroff' \
        -b 'Reboot' 'systemctl reboot'
        exec ${pkgs.systemd}/bin/systemctl --user import-environment
        include /etc/sway/config.d/*
      '';
    in
    {
      enable = true;
      settings = {
        default_session = {
          command = "${swayPkg}/bin/sway --config ${greetdSwayCfg}";
        };
      };
    };

  # Keep active sessions alive during `nixos-rebuild switch`.
  # NixOS can operate on both greetd.service and display-manager.service aliases;
  # guard both so unit changes do not bounce the login manager mid-session.
  systemd.services.greetd = {
    reloadIfChanged = false;
    restartIfChanged = false;
    stopIfChanged = false;
  };
  systemd.services.display-manager = {
    reloadIfChanged = false;
    restartIfChanged = false;
    stopIfChanged = false;
  };
}
