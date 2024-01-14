{ lib, config, pkgs, ... }:

{
  services.samba = {
    enable = false;
    enableNmbd = true;
    invalidUsers = [ "root" "avn" ];
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = bulldozer
      server role = standalone
      netbios name = bulldozer
      #use sendfile = yes
      #max protocol = smb2
      hosts allow = 172.16.228.0/24 172.16.229.0/24  localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      media = {
        path = "/mnt/media";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "nobody";
        "force group" = "nobody";
      };
      kris = {
        path = "/mnt/raid/kris";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "kris";
        "force group" = "users";
      };
    };
  };
  services.samba-wsdd = {
    enable = false;
    workgroup = "WORKGROUP";
    hostname = "bulldozer";
    interface = "enp9s0";
    hoplimit = 2;
  };
}
