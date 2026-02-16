{
  lib,
  pkgs,
  config,
  nixosConfig,
  ...
}:
let
  hostname = nixosConfig.networking.hostName;
  username = config.home.username;
  xkbcomp = pkgs.xkbcomp;
  xkb-sources = ./xkb;
  xkb-blob =
    host:
    pkgs.runCommand "xkb-blob-${host}" { } ''
      mkdir $out
      echo -I${xkb-sources}
      ${xkbcomp}/bin/xkbcomp -I${xkb-sources} -xkb -o $out/default.xkb ${xkb-sources}/models/${host}.xkb
    '';
  xkb = "${xkb-blob hostname}/default.xkb";
  xkb-script = pkgs.writeShellScriptBin "xkb-reload" ''
    ${xkbcomp}/bin/xkbcomp ${xkb} $DISPLAY >/dev/null 2>&1
  '';
in
{
  home.packages = [ xkb-script ];
  wayland.windowManager.sway = {
    config = rec {
      input = {
        "*" = {
          xkb_file = "${xkb}";
        };
      };
    };
  };
  xsession.initExtra = ''
    ${xkbcomp}/bin/xkbcomp ${xkb} $DISPLAY >/dev/null 2>&1
  '';
}
