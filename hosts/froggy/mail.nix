{ config, pkgs, lib, ... }:

let
  maildropWrapper = pkgs.writeScript "maildrop-wrapper" ''
    #!${pkgs.bash}/bin/sh -e
    PATH="${pkgs.maildrop}/bin:${pkgs.lockfileProgs}/bin:${pkgs.notmuch}/bin:${pkgs.coreutils}/bin:/bin:/usr/bin"
    export PATH
    ${pkgs.maildrop}/bin/maildrop "$@" || exit 75
  '';
  myDomains = [ "avnik.info" "mareicheva.info" "daemon.hole.ru" "alexawm.com" ];
in
{
  services = {
    postfix = {
      enable = true;
      hostname = "froggy";
      domain = "froggy.home";
      relayDomains = [ "bulldozer.avnik.info" "bulldozer.home" "daemon.hole.ru" "avnik.info" "mareicheva.info" "alexawm.com" ];
      rootAlias = "avn";
      postmasterAlias = "avn";
      origin = "avnik.info";
      relayHost = "10.1.0.3";
      networks = [ "172.16.228.0/24" ];
      extraConfig = ''
        mailbox_command = ${maildropWrapper} -d ''${USER}
        local_destination_concurrency_limit = 1
        local_destination_recipient_limit = 1
        soft_bounce = yes
        smtpd_recipient_restrictions =
          permit_mynetworks,
          reject_unauth_destination
      '';
      extraAliases = ''
        awm: avn
        alexawm: avn
        hans.black: avn
      '';
      transport = lib.concatMapStringsSep "\n" (x: "${x} relay:[172.16.228.3]") myDomains;
    };
    rspamd.enable = false;
  };
  networking.firewall.allowedTCPPorts = [ 25 ];

  environment = {
    systemPackages = with pkgs; [
      neomutt
      maildrop
    ];
  };
}
