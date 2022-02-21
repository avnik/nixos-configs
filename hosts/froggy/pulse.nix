{ config, pkgs, ... }:

let configF = pkgs.runCommand "system.pa" {} ''
   cat ${config.hardware.pulseaudio.package}/etc/pulse/system.pa \
     | sed '/module-native-protocol-unix/ s/$/ auth-group=pulse auth-group-enable=1 auth-anonymous=1/' \
     > $out
'';
in

{
      hardware.pulseaudio = {
          enable = true;
          systemWide = true;
          configFile = configF;
          daemon.config = {
              default-fragments = 10;
              default-fragment-size-msec = 2;
              default-sample-format = "s16le";
              default-sample-rate = 48000;
          };
      };

      # I use systemwide pulse on my desktops, so won't have him go away on upgrades
      systemd.services.pulseaudio.restartIfChanged = false;
}
