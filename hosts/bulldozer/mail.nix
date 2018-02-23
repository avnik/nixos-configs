{ config, pkgs, lib, ... }:

let maildropWrapper = pkgs.writeScript "maildrop-wrapper" ''
  #!${pkgs.bash}/bin/sh -e
  PATH="${pkgs.maildrop}/bin:${pkgs.notmuch}/bin:${pkgs.coreutils}/bin:/bin:/usr/bin"
  export PATH
  ${pkgs.maildrop}/bin/maildrop "$@" || exit 75
'';
in
{
  services = {
    dovecot2 = {
      enable = true;
      enableImap = true;
      enablePop3 = false;
      mailLocation = "maildir:/mnt/maildir/%u";
      modules = [ pkgs.dovecot_pigeonhole ];
    };
    postfix = {
      enable = true;
      hostname = "bulldozer";
      domain = "avnik.info";
      destination = [ "bulldozer.avnik.info" "bulldozer.home" "daemon.hole.ru"  "avnik.info"  "mareicheva.info" "master" "bulldozer" "alexawm.com" ];
      rootAlias = "avn";
      postmasterAlias = "avn";
      origin = "avnik.info";
      relayHost = "172.16.228.1";
      networks = [ "172.16.228.0/24" ];
      extraConfig = ''
        mailbox_size_limit = 512000000
        local_destination_concurrency_limit = 1
        local_destination_recipient_limit = 1
        soft_bounce = yes
        forward_path =
          /etc/users/$user/forward
          /home/$user/.forward
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
    etc = {
      "users/kris/forward" = { 
         text = "|${pkgs.dovecot}/libexec/dovecot/dovecot-lda";
         mode = "0444";
         user = "kris";
      };
      "users/olga/forward" = {
         text = "|${pkgs.dovecot}/libexec/dovecot/dovecot-lda";
         mode = "0444";
         user = "olga";
      };
      "users/avn/forward" = {
        text = "|${maildropWrapper}";
        mode = "0444";
        user = "avn";
      };
    };
    systemPackages = with pkgs; [
      neomutt procmail notmuch maildrop
    ];
  };
}
