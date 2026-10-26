{ lib, pkgs, ... }:

{
  services.journald.settings.Journal.ForwardToSyslog = false;

  systemd.tmpfiles.rules = [
    "d /var/log/cisco 0750 root adm - -"
  ];

  services.syslog-ng = {
    enable = true;
    extraConfig = ''
      source s_cisco {
        udp(ip("0.0.0.0") port(514) flags(no-parse));
      };

      parser p_cisco {
        cisco-parser();
      };

      destination d_cisco {
        file(
          "/var/log/cisco/$HOST.log"
          create-dirs(yes)
          owner("root")
          group("adm")
          perm(0640)
        );
      };

      log {
        source(s_cisco);
        parser(p_cisco);
        destination(d_cisco);
      };
    '';
  };

  services.logrotate.settings.cisco = {
    enable = true;
    files = "/var/log/cisco/*.log";
    frequency = "daily";
    rotate = 7;
    missingok = true;
    notifempty = true;
    postrotate = ''
      ${lib.getExe' pkgs.systemd "systemctl"} reload syslog-ng.service >/dev/null 2>&1 || true
    '';
  };
}
