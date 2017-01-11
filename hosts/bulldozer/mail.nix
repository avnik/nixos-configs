{ config, pkgs, lib, ... }:

let maildropWrapper = pkgs.writeScript "maildrop-wrapper" ''
  #!${pkgs.bash}/bin/sh -e
  PATH="${pkgs.maildrop}/bin:${pkgs.lockfileProgs}/bin:${pkgs.notmuch}/bin:${pkgs.coreutils}/bin:/bin:/usr/bin"
  export PATH
  #exec ${pkgs.lockfileProgs}/bin/with-lock-ex -q /tmp/mail-delivery-lock
  ${pkgs.maildrop}/bin/maildrop "$@" || exit 75
'';
in
{
  services = {
    postfix = {
      enable = true;
      hostname = "bulldozer";
      domain = "avnik.info";
      destination = [ "bulldozer.avnik.info" "bulldozer.home" "daemon.hole.ru"  "avnik.info"  "mareicheva.info" "master" "bulldozer"];
      rootAlias = "avn";
      postmasterAlias = "avn";
      origin = "avnik.info";
      relayHost = "frog.home";
      networks = [ "172.16.228.0/24" ];
      extraConfig = ''
        mailbox_command = ${maildropWrapper} -d ''${USER}
        local_destination_concurrency_limit = 1
        local_destination_recipient_limit = 1
        soft_bounce = yes
      '';
      extraAliases = ''
        awm: avn
        alexawm: avn
        hans.black: avn
      '';
    };
    rspamd.enable = true;
    rmilter.postfix.enable = true;
    rmilter.rspamd.extraConfig = ''
      spamd_never_reject = true;
    '';
  };

  environment = {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
    systemPackages = with pkgs; [
      neomutt procmail notmuch maildrop
    ];
  };
}
